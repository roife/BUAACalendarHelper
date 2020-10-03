//
//  EventCard.swift
//  BUAACal
//
//  Created by 吴家焱 on 10/3/20.
//

import SwiftUI

struct EventCard: View {
    @Environment(\.colorScheme) var colorScheme
    let data:CalendarEventDataModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading){
                    Text(data.eventName)
                        .font(.system(size: 22,
                                      weight: .bold,
                                      design: .rounded))
                        .padding(.bottom, 1)
                    
                    Text(data.indicatorName)
                        .font(.system(size: 14,
                                      design: .rounded))
                        .padding(.bottom, 3)
                    
                    Text("01:30 ~ 04:20")
                        .font(.system(size: 16,
                                      design: .rounded))
                }
                
                Spacer()
                
                VStack {
                    Text("@ \(data.locationName)")
                        .font(.system(size: 18,
                                      design: .rounded))
                }
            }
        }
        .padding(20)
        .background(colorScheme == .light ? colorNumbersLight[data.brightColorNumber] : colorNumbers[data.darkColorNumber])
        .cornerRadius(20)
        //        .padding(.bottom)
    }
}
