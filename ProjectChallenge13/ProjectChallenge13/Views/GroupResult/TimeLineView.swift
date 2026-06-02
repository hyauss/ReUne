//
//  TimeLineView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI

struct TimeLineView: View {
    
    let viewModelCalendar =  CalendarViewModel()
    let hours = Calendar.current.hourOfDay
    var mostFrequncyDate : String
    var secondFrequncyDate : String
    var datefilterArray: [Date]
    var dates: [Date]
    
    var body: some View {
        VStack{
            HStack{
                Text(" ")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity)
                Text(" ")
                    .font(.system(size: 14, weight: .medium))
                    .frame(maxWidth: .infinity)
                MostVoteHourComponent(date: mostFrequncyDate, color: .ultramarineBlue)
                    .frame(maxWidth: .infinity)
                
                if secondFrequncyDate == mostFrequncyDate {
                    Text(" ")
                        .frame(maxWidth: .infinity)
                }
                else{
                    MostVoteHourComponent(date: secondFrequncyDate, color: .formCardBack)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            ScrollView{
                VStack(spacing: -10){
                    ForEach(hours, id: \.self){
                        time in
                        TimeComponent(time: time, opacity1: viewModelCalendar.opacityForHour(dates: dates, day: mostFrequncyDate, hour: time),opacity2:secondFrequncyDate == mostFrequncyDate ? 0.1 :  viewModelCalendar.opacityForHour(dates: dates, day: secondFrequncyDate, hour: time) )
                    }
                }
            }
            .frame(height: 500)
            .overlay {
                VStack {
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    
                    Spacer()
                    
                    LinearGradient(
                        colors: [.clear, .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                }
                .allowsHitTesting(false)
            }
            .padding(.vertical)
        }
        .frame(width: 345)
        
    }
}

//#Preview {
//    TimeLineView(dateResult: ["",""], viewModel: CalendarViewModel())
//}
