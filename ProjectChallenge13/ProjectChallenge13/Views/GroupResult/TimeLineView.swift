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
            
            ScrollView{
                VStack(spacing: -10){
                    ForEach(hours, id: \.self){
                        time in
                        TimeComponent(time: time, opacity1: viewModelCalendar.opacityForHour(dates: dates, day: mostFrequncyDate, hour: time),opacity2:secondFrequncyDate == mostFrequncyDate ? 0.1 :  viewModelCalendar.opacityForHour(dates: dates, day: secondFrequncyDate, hour: time) )
                    }
                }
            }
        }
        
    }
}

//#Preview {
//    TimeLineView(dateResult: ["",""], viewModel: CalendarViewModel())
//}
