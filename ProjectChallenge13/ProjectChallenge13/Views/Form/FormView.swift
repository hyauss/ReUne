//
//  FormView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import SwiftUI
import CloudKit
import Aptabase

/// A form where the user selects dates and activities to submit to a group event.
struct FormView: View {
    /// The form view model that manages selected activities and dates.
    @State var formVM = FormViewModel()
    /// Activities loaded from ``FormViewModel``, filtered by the group's categories.
    @State var activities: [ActivitiesListModel] = []
    /// Activities converted to ``ActivitiesModel`` for display in ``ActivityMenu``.
    @State var newList: [ActivitiesModel] = []
    
    /// Triggers a view refresh when a new activity is successfully created.
    @Binding var newActivityCreated: Bool
    /// The CloudKit record of the current group, updated after saving.
    @Binding var groupCKRecord: CKRecord
    
    /// The group associated with this form.
    let group: EventGroup?
    
    /// The allowed date range for date selection, from today up to 2000 days ahead.
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
