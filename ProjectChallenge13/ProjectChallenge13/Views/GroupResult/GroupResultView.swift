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
        NavigationStack{
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            Text("Melhor Data")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }.frame(width: 345)
                        
                        CalendarView(dates: group.dates)
                    }
                    .padding(.top, 36)
                    
                    VStack(spacing:10){
                        HStack{
                            Text("Melhor Horário")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.gray)
                            Spacer()
                        }.frame(width: 345)
                            .padding(.bottom, 27)
                        
                        TimeLineView(mostFrequncyDate: viewModelCalendar.mostFrequencyDate(dates: group.dates), secondFrequncyDate: viewModelCalendar.secondFrequencyDate(dates: group.dates), datefilterArray: viewModelCalendar.filterDate(dates: group.dates, day: viewModelCalendar.mostFrequencyDate(dates: group.dates)), dates: group.dates)
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
    }
}

//#Preview {
//    GrupResultView()
//}
