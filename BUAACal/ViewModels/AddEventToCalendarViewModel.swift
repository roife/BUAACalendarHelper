//
//  AddEventToCalendarViewModel.swift
//  BUAACal
//
//  Created by roife on 10/10/20.
//

import Foundation
import EventKit

class AddEventToCalendarViewModel:ObservableObject {
    @Published var isFinished:Bool = false
    let eventStore : EKEventStore = EKEventStore()
    
    func addEventToCalendar(courses: [Date:[CalendarEvent<CalendarEventDataModel>]]) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            guard granted else {
                return
            }
            
            guard error == nil else {
                return
            }
            
            let newCalendar = self.createNewCalendar();
            
            for (_, eachDayCourse) in courses {
                for course in eachDayCourse {
                    let event:EKEvent = EKEvent(eventStore: self.eventStore)
                    event.title = course.data.eventName
                    event.startDate = course.data.startTime
                    event.endDate = course.data.endTime
                    event.notes = course.data.indicatorName
                    event.location = course.data.locationName
                    event.calendar = newCalendar
                    event.alarms = [EKAlarm(relativeOffset: -60*20)]
                    
                    do {
                        try self.eventStore.save(event, span: .thisEvent)
                    } catch let error {
                        print("failed to save event with error : \(error)")
                    }
                }
            }
        }
        self.isFinished = true
    }
    
    func createNewCalendar() -> EKCalendar {
        self.removeExistedEvents();
        
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        newCalendar.title = "BUAA Courses \(CalendarUtils.getCurrentYearString()) Term \(CalendarUtils.getCurrentTermString())"
        newCalendar.source = self.eventStore.defaultCalendarForNewEvents?.source
        do {
            try self.eventStore.saveCalendar(newCalendar, commit:true)
        } catch let error {
            print(error)
        }
        
        return newCalendar;
    }
    
    func removeExistedEvents() {
        let calendars = eventStore.calendars(for: .event)
        let buaaCalTitle = "BUAA Courses \(CalendarUtils.getCurrentYearString()) Term \(CalendarUtils.getCurrentTermString())"
        
        for calendar in calendars {
            if calendar.title == buaaCalTitle {
                do {
                    try eventStore.removeCalendar(calendar, commit: true)
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
