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
            TabView(selection: $currentMonthIndex.animation()){
                
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
                            ForEach(monthDate.calendarDisplayDays, id: \.self) { day in
                                
                                if day.monthInt != monthDate.monthInt {
                                    Text ("")
                                }
                                else{
                                    Text(day.formatted(.dateTime.day()))
                                        .font(day.formattedDate == viewModelCalendar.mostFrequencyDate(dates: dates) ? .title2 : .title3)
                                        .fontWeight(day.formattedDate == viewModelCalendar.mostFrequencyDate(dates: dates) ? .medium : .regular)
                                        .frame(maxWidth: .infinity, minHeight: 40)
                                        .foregroundStyle( day.formattedDate == viewModelCalendar.mostFrequencyDate(dates: dates) ? .white : .black)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(Color(hue: 0.669, saturation: viewModelCalendar.opacity(for: day, dates: dates) * 0.93, brightness: 1 - (0.40 * viewModelCalendar.opacity(for: day, dates: dates))))
                                                .frame(width: 40, height: 40)
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                    .tag(index)
                    
                }
                .frame(width: 345, height: 400, alignment: .top)
                .background(RoundedRectangle(cornerRadius: 20)
                    .frame(width: 345, height: 400)
                    .foregroundStyle(.white)
                    .shadow(radius: 4, y: 4)
                )
                .padding()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(alignment: .bottom){
                AnimationCalendarIndexView(numberOfPages: months.count, currentIndex: currentMonthIndex)
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
