//
//  CalendarView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 19/05/26.
//

import SwiftUI

/// Custom Calendar View with heat map
///- Parameter currentMonth: Continuously update the current month
///- Parameter days: Array about current month date
///- Parameter viewModel: called calendarViewModel
///- Parameter daysOfWeek: days of week
///- Parameter columns: size and number of grid
struct CalendarView: View {
    @State private var currentMonthIndex = Calendar.current.component(.month, from: Date.now) - 1
    @State private var animatedIndex = Calendar.current.component(.month, from: Date.now) - 1

    @State private var days: [Date] = []
    
    let viewModelCalendar =  CalendarViewModel()
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    let dates: [Date]
    
    let months = Calendar.current.monthSymbols
    
    var currentMonth: Date {
        Calendar.current.date(from: DateComponents(
            year: Calendar.current.component(.year, from: Date.now),
            month: currentMonthIndex + 1
        ))!
    }
    
    var body: some View {
        VStack{
            TabView(selection: $currentMonthIndex){
                
                ForEach(months.indices, id: \.self){ index in
                    let monthDate = Calendar.current.date(from: DateComponents(
                        year: Calendar.current.component(.year, from: Date.now),
                        month: index + 1
                    ))!
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            Text(monthDate.formatted(
                                .dateTime
                                    .year()
                                    .month(.wide)
                                    .locale(Locale(identifier: "pt_BR")))
                                .replacingOccurrences(of: " de ", with: " ")
                                .capitalized
                            )
                            .font(.title3)
                            .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        // Days of week
                        HStack {
                            ForEach(daysOfWeek.indices, id: \.self) { index in
                                Text(daysOfWeek[index])
                                    .font(.system(size: 14, weight: .semibold))
                                    .frame(maxWidth: .infinity)
                                    .foregroundStyle(.black.opacity(0.4))
                            }
                        }
                        
                        //date of month
                        LazyVGrid(columns: columns, spacing: 10) {
                            let mostFrequent = viewModelCalendar.mostFrequencyDate(dates: dates)
                            
                            ForEach(monthDate.calendarDisplayDays, id: \.self) { day in
                                
                                if day.monthInt != monthDate.monthInt {
                                    Color.clear.frame(height: 40)
                                } else {
                                    DayCellView(
                                        day: day,
                                        isMostFrequent: day.formattedDate == mostFrequent,
                                        opacity: viewModelCalendar.opacity(for: day, dates: dates)
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(width: 345, height: 400, alignment: .top)
                    .tag(index)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white)
                        .shadow(radius: 4, y: 4)
                    )
                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(alignment: .bottom){
                AnimationCalendarIndexView(numberOfPages: months.count, currentIndex: currentMonthIndex)
                    .animation(.easeInOut(duration: 0.2), value: currentMonthIndex)
            }
            .frame(height: 460, alignment: .top)
        }
    }
    
    /// update the days in month
    private func updateDays() {
        days = currentMonth.calendarDisplayDays
    }
}

#Preview {
    CalendarView(dates: [Date(), Date(), Date()])
}
