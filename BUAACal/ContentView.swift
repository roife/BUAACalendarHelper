//
//  ContentView.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    var events:[CalendarEvent<CalendarEventDataModel>] = [
            CalendarEvent(dateString: "2020-10-13",
                          data: CalendarEventDataModel(courseID: "BH380948",
                                                       eventName: "课程名",
                                                       startTime: Date(),
                                                       endTime: Date(),
                                                       weeks: "1, 2, 3, 4",
                                                       courseType: "必修",
                                                       credit: 2.3,
                                                       examType: 1,
                                                       lessons: "0203",
                                                       indicatorName: "我",
                                                       locationName: "地点",
                                                       brightColorNumber: 01,
                                                       darkColorNumber: 01))
        ]
        
        var body: some View {
            CalendarList<EventCard>(events: self.events) { event in
                EventCard(data: event.data)
            }
        }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
