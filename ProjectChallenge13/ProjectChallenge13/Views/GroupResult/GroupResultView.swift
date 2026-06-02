//
//  GrupResultView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI
import CloudKit
import Aptabase

struct GroupResultView: View {
    @StateObject private var vm = GroupViewModel.shared
    
    let viewModelCalendar = CalendarViewModel()
    let ckViewModel = LoginViewModel.shared

    var group: ItemViewModel
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            Text("Melhor Data")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .frame(width: 345)
                        
                        if group.dates.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 344)
                                    .shadow(color: .black.opacity(0.16), radius: 2, x: 2, y: 6)
                                
                                Text("Calendário sem nenhuma entrada")
                                    .padding()
                                    .foregroundStyle(.ultramarineBlue)
                            }
                        }
                        else {
                            CalendarView(dates: group.dates)
                        }
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing:10){
                        HStack{
                            Text("Melhor Horário")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }
                        .frame(width: 345)
                        .padding(.bottom, 27)
                        
                        if group.dates.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 344)
                                    .shadow(color: .black.opacity(0.16), radius: 2, x: 2, y: 6)
                                
                                Text("Horários sem nenhuma entrada")
                                    .padding()
                                    .foregroundStyle(.ultramarineBlue)
                            }
                        }
                        else {
                            TimeLineView(mostFrequncyDate: viewModelCalendar.mostFrequencyDate(dates: group.dates), secondFrequncyDate: viewModelCalendar.secondFrequencyDate(dates: group.dates), datefilterArray: viewModelCalendar.filterDate(dates: group.dates, day: viewModelCalendar.mostFrequencyDate(dates: group.dates)), dates: group.dates)
                        }
                    }
                    .padding(.top, 36)
                    
                    VStack{
                        HStack{
                            Text("Melhor Atividade")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }.frame(width: 345)
                        WordCloudView(group: group)
                    }
                    .padding(.top, 36)
                    
                }
            }
        }
        .navigationTitle("Resultados do Grupo")
        .onAppear {
            if !group.dates.isEmpty {
                let mostFreqDay = viewModelCalendar.mostFrequencyDate(dates: group.dates)
                let mostFreqHour = viewModelCalendar.mostFrequencyDate(dates: group.dates)

                // count votes per day of the week
                var weekdayCounts: [String: Int] = [:]
                var hourCounts: [String: Int] = [:]
                let cal = Calendar.current
                let dayFormatter = DateFormatter()
                dayFormatter.locale = Locale(identifier: "pt_BR")
                dayFormatter.dateFormat = "EEEE"
                let hourFormatter = DateFormatter()
                hourFormatter.dateFormat = "HH:00"
                
                for date in group.dates {
                    let day = dayFormatter.string(from: date)
                    let hour = hourFormatter.string(from: date)
                    weekdayCounts[day, default: 0] += 1
                    hourCounts[hour, default: 0] += 1
                }
                
                let topDay = weekdayCounts.max(by: { $0.value < $1.value })?.key ?? "N/A"
                let topHour = hourCounts.max(by: { $0.value < $1.value })?.key ?? "N/A"
                
                Aptabase.shared.trackEvent("group_result_opened", with: [
                    "most_popular_weekday": topDay,
                    "most_popular_hour": topHour,
                    "total_dates": group.dates.count,
                    "participants_count": group.users.count
                ])
            }
        }
    }
}

//#Preview {
//    GrupResultView()
//}
