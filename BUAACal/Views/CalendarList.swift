//
//  CalendarList.swift
//  CalendarList
//
//  Created by roife on 3/11/20.
//  Copyright © 2020 CalendarList. All rights reserved.
//

import SwiftUI

/// SwiftUI view to display paginated calendar months. When a given date is selected, all events for such date are represented below
/// according to the view-generation initializer block.
///
/// Parameters to initialize:
///   - initialDate: the initial month to be displayed will be extracted from this date. Defaults to the current day.
///   - calendar: `Calendar` instance to be used thorought the `CalendarList` instance. Defaults to the current `Calendar`.
///   - events: list of events to be displayed. Each event is an instance of `CalendarEvent`.
///   - selectedDateColor: color used to highlight the selected day. Defaults to the accent color.
///   - todayDateColor: color used to highlight the current day. Defaults to the accent color with 0.3 opacity.
///   - viewForEvent: `@ViewBuilder` block to generate a view per every event on the selected date. All the generated views for a given day will be presented in a `List`.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct CalendarList<Content: View>: View {
    @State private var months:[CalendarMonth]
    @State private var currentPage = 1
    
    @State public var selectedDate:Date = Date()
    
    @State public var isLogined = false
    @State public var isLoginSheetPresented = false
    @State public var showAlert = false
    //    @State public var isUpdating = false
    
    @ObservedObject var updatingVM = UpdatingViewModel()
    @ObservedObject var addEventVM = AddEventToCalendarViewModel()
    
    private let calendarDayHeight:CGFloat = 60
    private let calendar:Calendar
    
    //    private var events:[Date:[CalendarEvent<T>]]
    
    private var viewForEventBlock:(CalendarEvent<CalendarEventDataModel>) -> Content
    
    private var selectedDateColor:Color
    private var todayDateColor:Color
    
    /// Create a new paginated calendar SwiftUI view.
    /// - Parameters:
    ///   - initialDate: the initial month to be displayed will be extracted from this date. Defaults to the current day.
    ///   - calendar: `Calendar` instance to be used thorought the `CalendarList` instance. Defaults to the current `Calendar`.
    ///   - events: list of events to be displayed. Each event is an instance of `CalendarEvent`.
    ///   - selectedDateColor: color used to highlight the selected day. Defaults to the accent color.
    ///   - todayDateColor: color used to highlight the current day. Defaults to the accent color with 0.3 opacity.
    ///   - viewForEvent: `@ViewBuilder` block to generate a view per every event on the selected date. All the generated views for a given day will be presented in a `List`.
    public init(initialDate:Date = Date(),
                calendar:Calendar = Calendar.current,
                events:[CalendarEvent<CalendarEventDataModel>],
                selectedDateColor:Color = colorNumbersLight[1],
                todayDateColor:Color = colorNumbersLight[1].opacity(0.3),
                @ViewBuilder viewForEvent: @escaping (CalendarEvent<CalendarEventDataModel>) -> Content) {
        
        self.calendar = calendar
        _months = State(initialValue: CalendarMonth.getSurroundingMonths(forDate: initialDate, andCalendar: calendar))
        
        self.viewForEventBlock = viewForEvent
        
        self.selectedDateColor = selectedDateColor
        self.todayDateColor = todayDateColor
        
        updatingVM.events = Dictionary<Date, [CalendarEvent<CalendarEventDataModel>]>(grouping: events, by: { $0.date })
    }
    
    public var body: some View {
        if updatingVM.isUpdating {
            ProgressView("正在获取课程表 (\(updatingVM.cntFinished)/19)")
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear() {
                    updatingVM.updateEvents()
                }
        } else {
            NavigationView {
                commonBody
                    .navigationBarTitle("\(self.months[self.currentPage].monthTitle())", displayMode: .inline)
                    .navigationBarItems(leading: leadingButtons(), trailing: trailingButtons())
            }
        }
    }
    
    public var commonBody: some View {
        VStack {
            VStack {
                CalendarMonthHeader(calendar: self.months[1].calendar, calendarDayHeight: self.calendarDayHeight)
                
                HStack(alignment: .top) {
                    PagerView(pageCount: self.months.count, currentIndex: self.$currentPage, pageChanged: self.updateMonthsAfterPagerSwipe) {
                        ForEach(self.months, id:\.key) { month in
                            CalendarMonthView(month: month,
                                              calendar: self.months[1].calendar,
                                              selectedDate: self.$selectedDate,
                                              calendarDayHeight: self.calendarDayHeight,
                                              eventsForDate: updatingVM.events,
                                              selectedDateColor: self.selectedDateColor,
                                              todayDateColor: self.todayDateColor)
                        }
                    }
                }
                .frame(height: CGFloat(self.months[1].weeks.count) * self.calendarDayHeight)
            }
            
            Divider()
            
            List {
                ForEach(eventsForSelectedDate(), id:\.data) { event in
                    self.viewForEventBlock(event)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    func updateMonthsAfterPagerSwipe(newIndex:Int) {
        let newMonths = self.months[self.currentPage].getSurroundingMonths()
        
        if newIndex == 0 {
            self.months.remove(at: 1)
            self.months.remove(at: 1)
        } else { //newIndex == 2
            self.months.remove(at: 0)
            self.months.remove(at: 0)
        }
        
        self.months.insert(newMonths[0], at: 0)
        self.months.insert(newMonths[2], at: 2)
        
        self.currentPage = 1
    }
    
    func eventsForSelectedDate() -> [CalendarEvent<CalendarEventDataModel>] {
        let actualDay = CalendarUtils.resetHourPart(of: self.selectedDate, calendar:self.calendar)
        
        return updatingVM.events[actualDay] ?? []
    }
    
    func leadingButtons() -> some View {
        Button(action: {
            withAnimation {
                self.addEventVM.addEventToCalendar(courses: updatingVM.events)
            }
        }) {
            Image(systemName: "calendar.badge.plus").font(.title2)
        }
    }
    
    func trailingButtons() -> some View {
        HStack {
            Button(action: {
                if isLogined {
                    updatingVM.isUpdating = true
                    updatingVM.updateEvents()
                } else {
                    self.showAlert = true
                }
            }) {
                Image(systemName: "arrow.2.circlepath").font(.title2)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("登陆"), message: Text("需要登录之后才能更新课表！"), dismissButton: .default(Text("好")))
            }
            .padding(.trailing, 10)
            
            Button(action: {
                self.isLoginSheetPresented.toggle()
            }) {
                Image(systemName: "person.crop.circle").font(.title2)
            }
            .sheet(isPresented: $isLoginSheetPresented) {
                LoginSheet(isLoginSheetPresented: $isLoginSheetPresented,
                           isUpdating: $updatingVM.isUpdating,
                           isLogined: $isLogined)
            }
        }
    }
}
