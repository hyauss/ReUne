//
//  FormView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 25/05/26.
//

import SwiftUI
import CloudKit

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
    
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Complete com suas preferências sobre o evento")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 26)
                    
                    Text("Data e Horário")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.newGroupCategoriesText)
                    
                    ForEach(formVM.dateList.enumerated(), id: \.offset) { i, date in
                        DatePicker("", selection: $formVM.dateList[i], in: dateRange)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        formVM.dateList.append(Date())
                    } label: {
                        PlusButton()
                            .padding(.bottom, 40)
                            .padding(.top)
                    }
                    .onChange(of: formVM.dateList) {
                        print(formVM.dateList)
                    }
                    
                    Text("Atividades")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundStyle(.newGroupCategoriesText)
                    
                    
                    if group != nil && !newList.isEmpty {
                        ActivityMenu(activities: newList)
                    }
                    
                    ForEach(Array(formVM.selectedActivities), id: \.self) { activity in
                        ActivityCard(activity: activity)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear() {
                    //activities = formVM.filterActivities(categories: group?.categories!)
                }
                .environment(formVM)
                .onAppear() {
                    activities = formVM.filterActivities(categories: group!.categories)
                    newList = formVM.activityListModelToActivityModel(actv: activities)
                }
                
                FormToolbar(group: group!, newActivityCreated: $newActivityCreated, groupCKRecord: $groupCKRecord)
                    .environment(formVM)
            }
        }
    }
}

//#Preview {
//    FormView()
//}
