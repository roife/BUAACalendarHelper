//
//  CalendarEventData.swift
//  BUAACal
//
//  Created by 吴家焱 on 10/3/20.
//

import Foundation
import SwiftUI

struct CalendarEventDataModel: Hashable {
    let eventName: String
    let startTime: Date
    let endTime: Date
    let indicatorName: String
    let locationName: String
    let brightColorNumber: Int
    let darkColorNumber: Int
}
