//
//  CalendarMonthHeader.swift
//  CalendarList
//
//  Created by roife on 3/11/20.
//  Copyright © 2020 CalendarList. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct CalendarMonthHeader:View {
    let calendar:Calendar
    let calendarDayHeight:CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(CalendarUtils.weekdays, id:\.self) { weekday in
                        Text("\(weekday)")
                            .fontWeight(.semibold)
                            .frame(width: (geometry.size.width - 20) / 7,
                                   height: self.calendarDayHeight/2)
                    }
                    Spacer()
                }
            }
        }.frame(height: self.calendarDayHeight/2)
    }
}
