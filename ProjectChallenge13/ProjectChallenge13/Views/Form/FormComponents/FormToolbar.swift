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
    
    @Binding var newActivityCreated: Bool
    
    var body: some View {
        NavigationStack {
            Text("")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
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
                                                                                
                                        newActivityCreated.toggle()
                                    }
                                    catch {
                                        print(error.localizedDescription)
                                    }
                                }

                            } label: {
                                Image(systemName: "checkmark")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
        }
    }
}

//#Preview {
//    FormToolbar()
//}
