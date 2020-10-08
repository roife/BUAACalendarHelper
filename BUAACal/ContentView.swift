//
//  ContentView.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    var events = [
            CalendarEvent(dateString: "10/04/2020",
                          data: CalendarEventDataModel(eventName: "如何爬爬",
                                                       startTime: Date(),
                                                       endTime: Date(),
                                                       indicatorName: "吴家焱",
                                                       locationName: "543",
                                                       brightColorNumber: 0,
                                                       darkColorNumber: 0)),
            CalendarEvent(dateString: "10/04/2020",
                          data: CalendarEventDataModel(eventName: "如何膜佬",
                                                       startTime: Date(),
                                                       endTime: Date(),
                                                       indicatorName: "吴家焱",
                                                       locationName: "543",
                                                       brightColorNumber: 1,
                                                       darkColorNumber: 1))
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
