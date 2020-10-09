//
//  CalendarEventData.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import Foundation
import SwiftUI

public struct CalendarEventDataModel:Hashable {
    let eventName: String
    let startTime: Date
    let endTime: Date
    var indicatorName: String
    let locationName: String
    let brightColorNumber: Int
    let darkColorNumber: Int
    
    var getStartTimeAsString: String {
        let hm = Calendar.current.dateComponents([.hour, .minute], from: startTime)
        return "\(String(hm.hour!)):\(String(hm.minute!))"
    }
    
    var getEndTimeAsString: String {
        let hm = Calendar.current.dateComponents([.hour, .minute], from: endTime)
        return "\(String(hm.hour!)):\(String(hm.minute!))"
    }
}
