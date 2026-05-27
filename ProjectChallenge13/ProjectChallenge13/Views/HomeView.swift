//
//  HomeView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import CloudKit

struct HomeView: View {
    @StateObject private var vm =  GroupViewModel.shared
    
    @State var newGroupCreated: Bool = false
    @State var newActivityCreated: Bool = false
    
    @State var formRecord: CKRecord = CKRecord(recordType: "SeuTipo")
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    ForEach(Array(vm.items.enumerated()), id: \.element.recordId) { index, item in
                        NavigationLink {
                            GroupResultView(group: item)
                        } label: {
                            GroupCardComponent(groupNumber: index + 1)
                        }
                    }
                }
            }
            .navigationTitle("Seus Grupos")
            .toolbar{
                ToolbarItem(placement:.confirmationAction){
                    AddGroupButtonComponent(newGroupCreated: $newGroupCreated, formRecord: $formRecord)
                }
            }
            .navigationDestination(isPresented: $newGroupCreated) {
                FormView(newActivityCreated: $newActivityCreated, groupCKRecord: $formRecord, group: EventGroup.fromRecord(formRecord))
            }
            .navigationDestination(isPresented: $newActivityCreated) {
                if newActivityCreated == true  {
                    GroupResultView(group: ItemViewModel(itemListing: EventGroup.fromRecord(formRecord)!))
                }
            }
        }
    }
}
