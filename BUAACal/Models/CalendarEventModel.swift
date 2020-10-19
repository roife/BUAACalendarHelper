//
//  CalendarEvent.swift
//
//  Created by roife on 3/11/20.
//

import Foundation

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CalendarEvent<T: Hashable & Codable>: Hashable & Codable {
    public var date: Date
    public var data: T
    
    public var calendar: Calendar
    
    public init(calendar: Calendar = Calendar.current, date: Date, data: T) {
        self.calendar = calendar
        self.data = data
        self.date = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    }
    
    public init(calendar: Calendar = Calendar.current, dateString: String, dateFormat: String = "yyyy-MM-dd", data: T) {
        self.calendar = calendar
        self.data = data
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateString)!
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.date = calendar.date(from: components)!
    }
}
