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
    @State var notificationVM = PushNotificationViewModel.shared
    
    @State var newGroupCreated: Bool = false
    @State var newActivityCreated: Bool = false
    @State var formRecord: CKRecord = CKRecord(recordType: "SeuTipo")
    @State private var initialLoadDone: Bool = false
    @State private var deleteAlert: Bool = false
    
    // IDs that should show the shimmer
    @State private var shimmerIDs: Set<CKRecord.ID> = []
    @State private var knownIDs: Set<CKRecord.ID> = []
    @State private var isLogged: Bool = false
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationStack {
            if !isLogged {
                VStack {
                    ScrollViewReader { proxy in
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
                                    .id(item.recordID)
                                    .onAppear {
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
                        .onAppear {
                            isActive = true
                            vm.fetchGroupsWithUserId()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                                if let first = vm.records.first {
                                    withAnimation {
                                        proxy.scrollTo(first.recordID, anchor: .top)
                                    }
                                }
                            }
                        }
                        .onDisappear {
                            isActive = false
                        }
                        .onChange(of: vm.records) { newRecords in
                            if isActive, let first = newRecords.first {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    withAnimation {
                                        proxy.scrollTo(first.recordID, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                    .refreshable {
                        vm.fetchGroupsWithUserId()
                    }
                }
                .navigationTitle("Seus Grupos")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Menu {
                            Section("configurações") {
                                Button {
                                    deleteAlert.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: "trash")
                                        Text("Apagar Conta")
                                    }
                                }
                                
                                Button {
                                    if notificationVM.permitionState {
                                        for i in vm.records {
                                            notificationVM.unsubscribeToNotification(groupID: i.recordID.recordName)
                                        }
                                    }
                                    else {
                                        for i in vm.records {
                                            notificationVM.subscribeToNotification(groupID: i.recordID.recordName
                                            )
                                        }
                                    }
                                    notificationVM.permitionState.toggle()
                                } label: {
                                    HStack {
                                        Image(systemName: notificationVM.permitionState ? "bell.slash" : "bell")
                                        Text(notificationVM.permitionState ? "Notificações Desativadas" : "Notificações Ativadas")
                                    }
                                    .contentTransition(.symbolEffect(.replace.magic(fallback: .replace)))
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        AddGroupButtonComponent(newGroupCreated: $newGroupCreated, formRecord: $formRecord)
                    }
                }
                .alert("Tem certeza?", isPresented: $deleteAlert) {
                    Button(role: .destructive) {
                        ckViewModel.fetchAndDeletePreference()
                    } label: {
                        Text("Apagar")
                    }
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("Cancelar")
                    }
                } message: {
                    Text("Os dados de todos os seus grupos serão apagados juntamente com sua conta. Essa ação não poderá ser desfeita.")
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
                    
                    if isActive, let first = newRecords.first {
                        shimmerIDs.insert(first.recordID)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            shimmerIDs.remove(first.recordID)
                        }
                    }
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
            isActive = true
            vm.fetchGroupsWithUserId()
            if !ckViewModel.isLogged {
                isLogged.toggle()
            }
        }
        .onDisappear {
            isActive = false
        }
        
    }
}
