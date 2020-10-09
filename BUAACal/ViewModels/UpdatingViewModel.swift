//
//  UpdatingViewModel.swift
//  BUAACal
//
//  Created by roife on 10/4/20.
//

import Foundation
import SwiftUI

class UpdatingViewModel:ObservableObject {
    @Published var isUpdating: Bool = false
    @Published var events: [Date:[CalendarEvent<CalendarEventDataModel>]] = [:]
    @Published var courses: [CalendarEvent<CalendarEventDataModel>] = []
    
    struct eachClassJson:Codable {
        let id: String
        let year: String
        let term: String
        let course_id: String
        let course_name: String
        let location: String
        let weekday: String
        let lessons: String
        let teacher: String
        let week: String
        let course_time: String
        let course_type: String
        let credit: String
        let course_hour: String
        let khfs: String
        let lessArr: [Int]
        let order: Int
        let totalLength: Int
    }
    
    struct classJson:Codable {
        let c_1: [eachClassJson]?
        let c_2: [eachClassJson]?
        let c_3: [eachClassJson]?
        let c_4: [eachClassJson]?
        let c_5: [eachClassJson]?
        let c_6: [eachClassJson]?
        let c_7: [eachClassJson]?
        let c_8: [eachClassJson]?
        let c_9: [eachClassJson]?
        let c_10: [eachClassJson]?
        let c_11: [eachClassJson]?
        let c_12: [eachClassJson]?
        let c_13: [eachClassJson]?
        let c_14: [eachClassJson]?
    }
    
    struct dataJson:Codable {
        let classes: [classJson]
        let weekdays: [String]
    }
    
    struct resJson:Codable {
        let e: Int
        let m: String
        let d: dataJson?
    }
    
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
        courses = []
        events = [:]
        
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
                    self.events = Dictionary<Date, [CalendarEvent<CalendarEventDataModel>]>(grouping: self.courses,
                                                                                            by: { $0.date })
                    
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
                
                let responseString = String(data: data!, encoding: .utf8)
                
                let decoder = JSONDecoder()
                let json = try! decoder.decode(resJson.self,
                                               from: responseString!.data(using: .utf8)!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                
                if let days = json.d?.classes, let weekdays = json.d?.weekdays {
                    for (index, day) in days.enumerated() {
                        let c_n:[[eachClassJson]] = [day.c_1 ?? [],
                                                     day.c_2 ?? [],
                                                     day.c_3 ?? [],
                                                     day.c_4 ?? [],
                                                     day.c_5 ?? [],
                                                     day.c_6 ?? [],
                                                     day.c_7 ?? [],
                                                     day.c_8 ?? [],
                                                     day.c_9 ?? [],
                                                     day.c_10 ?? [],
                                                     day.c_11 ?? [],
                                                     day.c_12 ?? [],
                                                     day.c_13 ?? [],
                                                     day.c_14 ?? []]
                        
                        for c_i in c_n {
                            for course in c_i {
                                let courseTime = course.course_time.split(separator: "~")
                                print(weekdays[index] + courseTime[0])

                                if let startTime = dateFormatter.date(from: weekdays[index] + " " + courseTime[0]),
                                   let endTime = dateFormatter.date(from: weekdays[index] + " " + courseTime[1]) {
                                    self.courses.append(
                                        CalendarEvent(dateString: weekdays[index],
                                                      data: CalendarEventDataModel(eventName: course.course_name,
                                                                                   startTime: startTime,
                                                                                   endTime: endTime,
                                                                                   indicatorName: course.teacher,
                                                                                   locationName: course.location,
                                                                                   brightColorNumber: 01,
                                                                                   darkColorNumber: 01)))
                                }
                            }
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
