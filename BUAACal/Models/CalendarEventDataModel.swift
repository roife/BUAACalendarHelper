//
//  CalendarEventData.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import Foundation
import SwiftUI

public struct CalendarEventDataModel:Hashable {
    let courseID: String
    let eventName: String
    let startTime: Date
    let endTime: Date
    let weeks: String
    let courseType: String
    let credit: Double
    let examType: Int
    let lessons: String
    var indicatorName: String // Maybe modified
    let locationName: String
    let brightColorNumber: Int
    let darkColorNumber: Int
    
    var getStartTimeAsString: String {
        let dateFormmter = DateFormatter()
        dateFormmter.dateFormat = "HH:mm"
        return "\(dateFormmter.string(from: startTime))"
    }
    
    var getEndTimeAsString: String {
        let dateFormmter = DateFormatter()
        dateFormmter.dateFormat = "HH:mm"
        return "\(dateFormmter.string(from: endTime))"
    }
}
