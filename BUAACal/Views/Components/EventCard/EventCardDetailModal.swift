//
//  EventCardDetailModal.swift
//  BUAACal
//
//  Created by roife on 10/13/20.
//

import SwiftUI

struct EventCardDetailModal: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var showModal:Bool
    let data:CalendarEventDataModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Spacer()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading){
                        Text(data.eventName)
                            .font(.system(size: 28,
                                          weight: .bold,
                                          design: .rounded))
                            .padding(.top, 3)
                        
                        Text(data.courseID)
                            .font(.system(size: 16,
                                          weight: .light,
                                          design: .rounded))
                            .padding(.bottom, 3)
                        
                        Text("\(data.getStartTimeAsString) ~ \(data.getEndTimeAsString)")
                            .font(.system(size: 18,
                                          weight: .semibold,
                                          design: .rounded))
                            .padding(.bottom, 1)
                        
                        Text("@ \(data.locationName)")
                            .font(.system(size: 18,
                                          design: .rounded))
                            .padding([.trailing], 0)
                            .padding(.bottom, 3)
                        
                        VStack(alignment: .leading) {
                            Text("教师：\(data.indicatorName)")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("学分：\(String(format: "%.2f", data.credit))")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("类型：\(data.courseType)")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("时间：第 \(data.lessons.separate(every: 2, with: ",")) 节")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("课时：\(data.courseHour) 小时")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("上课星期：\(data.weeks)")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                            
                            Text("考查方式：\(data.examType)")
                                .font(.system(size: 17,
                                              design: .rounded))
                                .padding(.bottom, 1)
                        }
                        
                    }
                    Spacer()
                }
                .padding(15)
                .background(colorScheme == .light
                                ? colorNumbersLight[data.brightColorNumber]
                                : colorNumbers[data.darkColorNumber])
                .cornerRadius(15)
                .shadow(radius: 10)
                
                Spacer()
            }
            
            HStack {
                Button() {
                    withAnimation {
                        showModal.toggle()
                    }
                } label: {
                    Spacer()
                    
                    Text("完成")
                    
                    Spacer()
                }
                .padding(15)
                .background(colorScheme == .light
                                ? colorNumbersLight[data.brightColorNumber]
                                : colorNumbers[data.darkColorNumber])
                .foregroundColor(colorScheme == .light ? .black : .white)
                .cornerRadius(45)
                .frame(minWidth: 0, maxWidth: .infinity)
                .shadow(radius: 1)
            }
            .padding([.leading], 5)
            .padding([.trailing], 5)
        }
    }
}
