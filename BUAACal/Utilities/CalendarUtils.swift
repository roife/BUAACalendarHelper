//
//  CalendarUtils.swift
//  CalendarList
//
//  Created by roife on 3/11/20.
//  Copyright © 2020 CalendarList. All rights reserved.
//

import Foundation

public struct CalendarUtils {
    
    public static let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
    
    public static func isSameDay(date1:Date, date2:Date, calendar:Calendar) -> Bool {
        return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedSame
    }
    
    public static func resetHourPart(of date:Date, calendar:Calendar) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
    public static func getCalendarMonthFor(year:Int, month:Int, calendar:Calendar) -> CalendarMonth {
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        
        let newDate = calendar.date(from: comps)!
        
        return getCalendarMonthFor(date: newDate, calendar: calendar)
    }
    
    public static func getCalendarMonthFor(date:Date, calendar:Calendar) -> CalendarMonth {
        var comps = DateComponents()
        comps.year = calendar.component(.year, from: date)
        comps.month = calendar.component(.month, from: date)
        comps.day = 1
        
        let newDate = calendar.date(from: comps)!
        
        var grouped:[[Date]] = [[]]
        var currentGroupIndex = 0
        var totalDaysProcessed = 0
        
        for j in calendar.range(of: .day, in: .month, for: newDate)! {
            
            let dailyDate = calendar.date(bySetting: .day, value: j, of: newDate)!
        
            if calendar.component(.weekday, from: dailyDate) == calendar.firstWeekday && totalDaysProcessed > 0 {
                currentGroupIndex += 1
                
                grouped.append([])
            }
            
            grouped[currentGroupIndex].append(dailyDate)
            
            totalDaysProcessed += 1
        }
        
        return CalendarMonth(calendar: calendar,
                             actualDate: newDate,
                             weeks: grouped)
    }
    
    public static func getCurrentYearString() -> String {
        let calendar = Calendar.current
        let year = calendar.dateComponents([.year], from: Date()).year!
        return "\(year)-\(year+1)"
    }
    
    public static func getCurrentTermString() -> String {
        let calendar = Calendar.current
        let month = calendar.dateComponents([.month], from: Date()).month!
        return "\(month <= 7 ? "2" : "1")"
    }
}
