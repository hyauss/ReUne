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

struct FormToolbar: View {
    @StateObject private var vm =  GroupViewModel.shared
    @Environment(FormViewModel.self) var formVM
    
    @State var group: EventGroup
    @State var showingCreateAlert: Bool = false
    
    @Binding var newActivityCreated: Bool
    @Binding var groupCKRecord: CKRecord
    
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
                                            let normalize: (Date) -> Date = { date in
                                                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                                                return calendar.date(from: components) ?? date
                                            }

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
                                                    } else {
                                                        existingActivities.append(selectedActivity)
                                                    }
                                                }
                                                let activitiesData = try JSONEncoder().encode(existingActivities)
                                                groupRecord["activities"] = activitiesData
                                            }
                                            
                                            groupRecord["dates"] = existingDates as CKRecordValue
                                            await vm.save(groupRecord: groupRecord)
                                            groupCKRecord = groupRecord
                                            newActivityCreated.toggle()
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    Aptabase.shared.trackEvent("new_event")
                                    showingCreateAlert = true
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .buttonStyle(.borderedProminent)
                                .alert("Atividade inserida com sucesso!", isPresented: $showingCreateAlert) {
                                    Button {
                                        newActivityCreated.toggle()
                                    } label: {
                                        Text("Ver Resultados")
                                    }
                                }
                            
                        }
                    }
                }
        }
    }
}

//#Preview {
//    FormToolbar()
//}
