//
//  FormView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import SwiftUI
import CloudKit
import Aptabase

struct FormView: View {
    
    @State var formVM = FormViewModel()
    @State var activities: [ActivitiesListModel] = []
    @State var newList: [ActivitiesModel] = []
    
    @Binding var newActivityCreated: Bool
    @Binding var groupCKRecord: CKRecord
        
    let group: EventGroup?
    
    let dateRange: ClosedRange<Date> = {
        let now = Date.now
        return now...Calendar.current.date(byAdding: .day, value: 2000, to: now)!
    }()
    
    /// Helper: name of the day of the week for aptabase
    private func weekdayName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    /// Helper: formated time for aptabase
    private func hourString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:00"
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.formBackgroud
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Complete com suas preferências sobre o evento")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.bottom, 26)
                            .foregroundStyle(.formMainText)
                            .padding(.top)
                        
                        Text("Data e Horário")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.formSecText)
                        
                        ForEach(formVM.dateList.enumerated(), id: \.offset) { i, date in
                            HStack {
                                DatePicker("", selection: $formVM.dateList[i], in: dateRange)
                                    .colorInvert()
                                    .colorMultiply(.formCardText)
                                    .colorScheme(.light)
                                    .labelsHidden()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Button {
                                    formVM.dateList.remove(at: i)
                                } label: {
                                    Image(systemName: "minus")
                                }
                                .buttonStyle(.bordered)
                                
                                Spacer()
                            }
                            .padding(.bottom, 7)
                        }
                        
                        Button {
                            formVM.dateList.append(Date())
                        } label: {
                            PlusButton()
                                .padding(.bottom, 40)
                                //.padding(.top)
                        }
                        .onChange(of: formVM.dateList) {
                            print(formVM.dateList)
                            
                            let days = formVM.dateList.map { weekdayName(from: $0) }
                            let hours = formVM.dateList.map { hourString(from: $0) }
                            // avarege of availability of day and time.
                            Aptabase.shared.trackEvent("availability_updated", with: [
                                "days_count": formVM.dateList.count,
                                "weekdays": days.joined(separator: ", "),
                                "hours": hours.joined(separator: ", ")
                            ])
                        }
                        
                        Text("Atividades")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.formSecText)
                        
                        
                        if group != nil && !newList.isEmpty {
                            ActivityMenu(activities: newList)
                        }
                        
                        ForEach(Array(formVM.selectedActivities), id: \.self) { activity in
                            ActivityCard(activity: activity)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .environment(formVM)
                    .onAppear() {
                        activities = formVM.filterActivities(categories: group!.categories)
                        newList = formVM.activityListModelToActivityModel(actv: activities)
                    }
                    
                    FormToolbar(group: group!, newActivityCreated: $newActivityCreated, groupCKRecord: $groupCKRecord)
                        .environment(formVM)
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .background(.formBackgroud)
    }
}

//#Preview {
//    FormView()
//}
