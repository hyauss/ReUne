//
//  GrupResultView.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI
import CloudKit

struct GroupResultView: View {
    @StateObject private var vm = GroupViewModel.shared
    
    let viewModelCalendar = CalendarViewModel()

    var group: ItemViewModel
    
    var body: some View {
        ScrollView{
            VStack{
                
                
                CalendarView(dates: group.dates)
                
                TimeLineView(mostFrequncyDate: viewModelCalendar.mostFrequencyDate(dates: group.dates), secondFrequncyDate: viewModelCalendar.secondFrequencyDate(dates: group.dates), datefilterArray: viewModelCalendar.filterDate(dates: group.dates, day: viewModelCalendar.mostFrequencyDate(dates: group.dates)), dates: group.dates)
                
                WordCloudView(group: group)
                
                
            }
        }
    }
}

//#Preview {
//    GrupResultView()
//}
