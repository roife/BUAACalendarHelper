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
                    event.notes = """
                        编号：\(course.data.courseID)
                        名称：\(course.data.eventName)
                        教师：\(course.data.indicatorName)
                        学分：\(course.data.credit)
                        类型：\(course.data.courseType)
                        课时：\(course.data.courseHour)
                        上课星期：\(course.data.weeks)
                        上课时间：\(course.data.getStartTimeAsString) ~ \(course.data.getEndTimeAsString)；第 \(course.data.lessons.separate(every: 2, with: ",")) 节课
                        考查方式：\(course.data.examType)
                        """
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

extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}
