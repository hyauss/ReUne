//
//  MostVoteHourComponent.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 27/05/26.
//

import SwiftUI

struct MostVoteHourComponent: View {
    let viewModelCalendar =  CalendarViewModel()
    var date: String
    
    var body: some View {
        VStack{
            Text(viewModelCalendar.dayNumber(from: date))
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(viewModelCalendar.weekdayAbbreviation(from: date))
                .font(.callout)
                .fontWeight(.semibold)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 56, height: 64)
                .foregroundStyle(.yellow)
                .shadow(radius: 4, y: 4)
        )
        
    }
}

//#Preview {
//    MostVoteHourComponent()
//}
