//
//  ContentView.swift
//  BUAACal
//
//  Created by roife on 10/3/20.
//

import SwiftUI

struct ContentView: View {
    let events = DataStorage.loadData()
    
    var body: some View {
        CalendarList<EventCard>(events: self.events) { event in
            EventCard(data: event.data)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
