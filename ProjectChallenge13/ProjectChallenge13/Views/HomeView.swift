//
//  HomeView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import CloudKit

struct HomeView: View {
    @StateObject private var vm = GroupViewModel.shared
    @State var ckViewModel = LoginViewModel.shared
    @State var newGroupCreated: Bool = false
    @State var newActivityCreated: Bool = false
    @State var formRecord: CKRecord = CKRecord(recordType: "SeuTipo")
    @State private var initialLoadDone: Bool = false

    // IDs that should show the shimmer
    @State private var shimmerIDs: Set<CKRecord.ID> = []
    @State private var knownIDs: Set<CKRecord.ID> = []
    @State private var isLogged: Bool = false

    var body: some View {
        NavigationStack {
            if !isLogged {
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(Array(vm.records.enumerated()), id: \.element.recordID) { index, item in
                                let total = vm.records.count
                                let groupNumber = max(1, total - index)
                                let eventGroup = EventGroup.fromRecord(item) ?? EventGroup(
                                    recordId: item.recordID, users: Set<String>(),
                                    categories: [], activities: [], dates: [], owner: ""
                                )
                                let itemVM = ItemViewModel(itemListing: eventGroup)
                                let isNew = shimmerIDs.contains(item.recordID)
                                
                                NavigationLink {
                                    GroupResultView(group: itemVM)
                                } label: {
                                    GroupCardComponent(groupNumber: groupNumber, item: itemVM)
                                        .shimmerBorder(animate: isNew)
                                }
                                .onAppear {
                                    // Remove o ID do set após a animação terminar
                                    if isNew {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                                            shimmerIDs.remove(item.recordID)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                    }
                    .refreshable {
                        vm.fetchGroupsWithUserId()
                    }
                }
                .navigationTitle("Seus Grupos")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        AddGroupButtonComponent(newGroupCreated: $newGroupCreated, formRecord: $formRecord)
                    }
                }
                // Detecta novos records comparando com os já conhecidos
                .onChange(of: vm.records) { newRecords in
                    let newIDs = Set(newRecords.map { $0.recordID })
                    
                    if !initialLoadDone {
                        // Anima só o card mais recente
                        if let first = newRecords.first {
                            shimmerIDs.insert(first.recordID)
                        }
                        knownIDs = newIDs
                        initialLoadDone = true
                        return
                    }
                    
                    // Anima apenas os cards novos
                    let addedIDs = newIDs.subtracting(knownIDs)
                    if !addedIDs.isEmpty {
                        shimmerIDs.formUnion(addedIDs)
                    }
                    knownIDs = newIDs
                }
                .onChange(of: vm.needFetch) {
                    Task {
                        try? await Task.sleep(for: .seconds(2))
                        vm.fetchGroupsWithUserId()
                        vm.needFetch = false
                    }
                }
                .navigationDestination(isPresented: $newGroupCreated) {
                    FormView(newActivityCreated: $newActivityCreated,
                             groupCKRecord: $formRecord,
                             group: EventGroup.fromRecord(formRecord))
                }
                .navigationDestination(isPresented: $newActivityCreated) {
                    if newActivityCreated {
                        GroupResultView(group: ItemViewModel(
                            itemListing: EventGroup.fromRecord(formRecord)!
                        ))
                    }
                }
            }
            else {
                EntryView()
            }
        }
        .onAppear {
            vm.fetchGroupsWithUserId()
            if !ckViewModel.isLogged {
                isLogged.toggle()
            }
        }
            
    }
}
