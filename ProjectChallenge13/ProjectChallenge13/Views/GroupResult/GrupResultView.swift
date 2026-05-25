//
//  GrupResultView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI

struct GrupResultView: View {

    let viewModel = CalendarViewModel()
    let datesResult = [Date(), Date(), Date()]
    let mockDates: [Date] = [
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 10, hour: 10))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 11))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 12))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 15, hour: 12))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 22, hour: 10))!,
        Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 20, hour: 10))!
    ]
    
    var body: some View {
        ScrollView{
            VStack{
                
                CalendarView(viewModel: viewModel, dates: mockDates)
                
                TimeLineView(viewModel: viewModel, mostFrequncyDate: viewModel.mostFrequencyDate(dates: mockDates), secondFrequncyDate: viewModel.secondFrequencyDate(dates: mockDates), datefilterArray: viewModel.filterDate(dates: mockDates, day: viewModel.mostFrequencyDate(dates: datesResult)), dates: mockDates)
            }
        }
    }
}

#Preview {
    GrupResultView()
}
