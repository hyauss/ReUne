//
//  FormToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import Foundation
import SwiftUI
import CloudKit
import Aptabase

/// A toolbar that allows the user to submit selected activities and dates to the group.
struct FormToolbar: View {
    /// The shared group view model used to fetch and save CloudKit records.
    @StateObject private var vm =  GroupViewModel.shared
    
    @StateObject private var store = StoreKitManager.shared
    @StateObject private var adManager = AdManager.shared
    
    /// The form view model that holds the selected activities and dates.
    @Environment(FormViewModel.self) var formVM
    
    /// The group to which the activities and dates will be added.
    @State var group: EventGroup
    /// Controls the visibility of the success alert.
    @State var showingCreateAlert: Bool = false
    
    /// Triggers a view refresh when a new activity is successfully created.
    @Binding var newActivityCreated: Bool
    /// The CloudKit record of the current group, updated after saving.
    @Binding var groupCKRecord: CKRecord
    
    let pushVM = PushNotificationViewModel.shared
    
    
    var body: some View {
        NavigationStack {
            Text("")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Spacer()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        if !formVM.dateList.isEmpty && !formVM.selectedActivities.isEmpty {
                            Button {
                                Task {
                                    do {
                                        let groupRecord = try await vm.fetchGroupsWithId(groupID: group.recordId!.recordName)
                                        
                                        var existingDates = groupRecord["dates"] as? [Date] ?? []
                                        
                                        let calendar = Calendar.current
                                        
                                        // Remove the seconds from the date
                                        let normalize: (Date) -> Date = { date in
                                            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                            return calendar.date(from: components) ?? date
                                        }
                                        
                                        // filter the duplicate dates
                                        let uniqueNewDates = formVM.dateList
                                            .map { normalize($0) }
                                            .reduce(into: [Date]()) { result, date in
                                                if !result.contains(date) {
                                                    result.append(date)
                                                }
                                            }
            
                                        existingDates.append(contentsOf: uniqueNewDates)
                                        groupRecord["dates"] = existingDates as CKRecordValue
                                        
                                        if let existingActivitiesData = groupRecord["activities"] as? Data,
                                           var existingActivities = try? JSONDecoder().decode([ActivitiesModel].self, from: existingActivitiesData) {
                                            for selectedActivity in formVM.selectedActivities {
                                                if let index = existingActivities.firstIndex(where: { $0.name == selectedActivity.name }) {
                                                    existingActivities[index].votos += 1
                                                }
                                                else {
                                                    existingActivities.append(selectedActivity)
                                                }
                                            }
                                            let activitiesData = try JSONEncoder().encode(existingActivities)
                                            groupRecord["activities"] = activitiesData
                                        }
                                        
                                        groupRecord["dates"] = existingDates as CKRecordValue
                                        await vm.save(groupRecord: groupRecord)
                                        groupCKRecord = groupRecord
                                        let groupID = groupCKRecord.recordID.recordName
                                        if pushVM.permitionState == true{
                                            pushVM.subscribeToNotification(groupID: groupID)
                                        }
                                        
    
                                        showingCreateAlert = true
                                    }
                                    catch {
                                        print(error.localizedDescription)
                                    }
                                }
                                Aptabase.shared.trackEvent("new_groupAnswer")
                                showingCreateAlert = true
                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.borderedProminent)
                            .alert("Atividade inserida com sucesso!", isPresented: $showingCreateAlert) {
                                Button {
                                    navigateToResult()
                                } label: {
                                    Text("Ver Resultados")
                                }
                            }
                        }
                    }
                }
        }
    }
    
    private func navigateToResult() {
            if store.isPremium {
                newActivityCreated = true
            } else {
                adManager.showAdAfterVoting {
                    newActivityCreated = true
                }
            }
        }
}

