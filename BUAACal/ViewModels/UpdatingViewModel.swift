//
//  UpdatingViewModel.swift
//  BUAACal
//
//  Created by 吴家焱 on 10/4/20.
//

import Foundation
import SwiftUI

class UpdatingViewModel:ObservableObject {
    @Published var isUpdating: Bool = false
    @Published var events: [Date:[CalendarEvent<CalendarEventDataModel>]] = [:]
    
    func updateEvents() {
        let cookieName = "eai-sess"
        guard let cookie = HTTPCookieStorage.shared.cookies?.first(where: { $0.name == cookieName })?.value else {
            return
        }
        
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: Date()).year!
        let month = calendar.dateComponents([.month], from: Date()).month!
        
        let url = URL(string: "https://app.buaa.edu.cn/timetable/wap/default/get-datatmp")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36", forHTTPHeaderField: "User-Agent")
        request.setValue("\(cookieName)=\(cookie)", forHTTPHeaderField: "Cookie")
        
        var cntFinished = 0;
        
        for week in 1...19 {
            let body: [String: Any] = [
                "year": "\(year)-\(year+1)",
                "term": month <= 7 ? "2" : "1",
                "week": String(week),
                "type": "2"
            ]
            
            request.httpBody = body.percentEncoded()
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                cntFinished += 1
                if cntFinished == 19 {
                    self.isUpdating.toggle()
                    let courses = [
                            CalendarEvent(dateString: "10/09/2020",
                                          data: CalendarEventDataModel(eventName: "如何爬爬",
                                                                       startTime: Date(),
                                                                       endTime: Date(),
                                                                       indicatorName: "吴家焱",
                                                                       locationName: "543",
                                                                       brightColorNumber: 0,
                                                                       darkColorNumber: 0)),
                            CalendarEvent(dateString: "10/09/2020",
                                          data: CalendarEventDataModel(eventName: "如何膜佬",
                                                                       startTime: Date(),
                                                                       endTime: Date(),
                                                                       indicatorName: "吴家焱",
                                                                       locationName: "543",
                                                                       brightColorNumber: 1,
                                                                       darkColorNumber: 1))
                        ]
                    self.events = Dictionary<Date, [CalendarEvent<CalendarEventDataModel>]>(grouping: courses, by: { $0.date })
                    
                }
                
                guard let _ = data,
                      let response = response as? HTTPURLResponse,
                      error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
//                let responseString = String(data: data!, encoding: .utf8)
//                    print("responseString = \(responseString)")
                
                
            }
            
            task.resume()
        }
    }
}
