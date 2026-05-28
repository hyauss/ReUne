//
//  FormToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import Foundation
import SwiftUI
import CloudKit

struct FormToolbar: View {
    @StateObject private var vm =  GroupViewModel.shared
    @Environment(FormViewModel.self) var formVM
    
    @State var group: EventGroup
    @State var showingAlert: Bool = false
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
                        HStack {
                            if !formVM.dateList.isEmpty && !formVM.selectedActivities.isEmpty {
                                Button {
                                    for selectedActivity in formVM.selectedActivities {
                                        if let index = group.activities.firstIndex(where: { $0.name == selectedActivity.name }) {
                                            group.activities[index].votos += 1
                                        } else {
                                            group.activities.append(selectedActivity)
                                        }
                                    }
                                    for selectedDate in formVM.dateList {
                                        group.dates.append(selectedDate)
                                    }
                                    
                                    Task {
                                        do {
                                            let groupRecord = try await vm.fetchGroupsWithId(groupID: group.recordId!.recordName)
                                            let activitiesData = try JSONEncoder().encode(group.activities)
                                            groupRecord["activities"] = activitiesData
                                            groupRecord["dates"] = group.dates
                                            await vm.save(groupRecord: groupRecord)
                                            groupCKRecord = groupRecord
                                            newActivityCreated.toggle()
                                        }
                                        catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    showingCreateAlert = true
                                    
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .buttonStyle(.borderedProminent)
//                                .alert("Preencha todos os campos para prosseguir", isPresented: $showingAlert) {
//                                    Button("OK", role: .close) { }
//                                }
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
}

//#Preview {
//    FormToolbar()
//}
