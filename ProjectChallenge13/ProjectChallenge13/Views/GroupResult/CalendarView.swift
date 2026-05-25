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
    @State private var currentMonth = Date.now
    @State private var days: [Date] = []
    
    let viewModelCalendar =  CalendarViewModel()
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    let dates: [Date]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Month
            HStack {
                Text(currentMonth.formatted(.dateTime.year().month()))
                    .font(.system(size: 16, weight: .bold))
                
                Spacer()
                
                Button {
                    currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth)!
                    updateDays()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                
                Button {
                    currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth)!
                    updateDays()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
            }
            
            // Days of week
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black.opacity(0.5))
                }
            }
            
            //date of month
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days, id: \.self) { day in
                    
                    if day.monthInt != currentMonth.monthInt {
                        Text ("")
                    }
                    else{
                        Text(day.formatted(.dateTime.day()))
                            .font(.system(size: 14, weight: .medium))
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .foregroundStyle(Date.now.startOfDay == day.startOfDay ? .pink : .black)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(Color(hue: 0.9, saturation: viewModelCalendar.opacity(for: day, dates: dates), brightness: 1))
                            )
                    }
                }
            }
        }
        .padding()
        .onAppear{
            updateDays()
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
