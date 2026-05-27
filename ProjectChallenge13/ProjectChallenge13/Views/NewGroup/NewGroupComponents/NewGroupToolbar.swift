//
//  NewGroupToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

struct NewGroupToolbar: View {
    @Environment(ContactsViewModel.self) private var contactsVM
    @Environment(NewGroupViewModel.self) var newGroupVM
    
    @StateObject private var vm =  GroupViewModel.shared
    
    @Binding var showMessage: Bool
    //@Binding var newGroupCreated: Bool
    @Binding var isDismiss: Bool
    @Binding var isDismissNotSave: Bool
    @State var ckViewModel = LoginViewModel.shared
    @State private var users: Set<String> = []
      
    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if !newGroupVM.selectedCategory.isEmpty {
                        
                        Button {
                            //if !newGroupVM.selectedCategory.isEmpty {
                            users.insert(ckViewModel.preference!.userID)
                            newGroupVM.record = vm.saveItem(categories: Array(newGroupVM.selectedCategory), activities: [], dates: [], users: users, owner: ckViewModel.preference!.userID)
                            
                            if !contactsVM.selectedContacts.isEmpty {
//                                group = ItemViewModel(itemListing: EventGroup.fromRecord(newGroupVM.record!)!)
                                showMessage = true
                            }
                            else {
                                isDismiss.toggle()
                            }
                            
                        } label: {
                            Image(systemName: "checkmark")
                        }
                    }
                    
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isDismissNotSave.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Novo Grupo")
                }
            }
    }
}
