//
//  GrupResultView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI
import CloudKit

struct GrupResultView: View {
    @StateObject private var vm = GroupViewModel.shared
    
    let viewModelCalendar = CalendarViewModel()
    let mockDates: [Date] = [
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 10))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 11))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 12))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 12))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 22, hour: 10))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 20, hour: 10))!
    ]

    var group: EventGroup
    
    var body: some View {
        ScrollView{
            VStack{
                
                
                CalendarView(dates: group.dates)
                
                TimeLineView(mostFrequncyDate: viewModelCalendar.mostFrequencyDate(dates: mockDates), secondFrequncyDate: viewModelCalendar.secondFrequencyDate(dates: mockDates), datefilterArray: viewModelCalendar.filterDate(dates: mockDates, day: viewModelCalendar.mostFrequencyDate(dates: mockDates)), dates: mockDates)
                
                
            }
        }
    }
}

//#Preview {
//    GrupResultView()
//}
