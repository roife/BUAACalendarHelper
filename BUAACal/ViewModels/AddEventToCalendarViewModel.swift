//
//  AddEventToCalendarViewModel.swift
//  BUAACal
//
//  Created by roife on 10/10/20.
//

import Foundation
import EventKit

class AddEventToCalendarViewModel:ObservableObject {
    func addEventToCalendar(courses: [CalendarEvent<CalendarEventDataModel>]) {
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            guard granted else {
                return
            }
            
            guard error == nil else {
                return
            }
            
            for course in courses {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = course.data.eventName
                event.startDate = course.data.startTime
                event.endDate = course.data.endTime
                event.notes = course.data.indicatorName
                event.location = course.data.locationName
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
            }
        }
    }
}
