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
    @Binding var newGroupCreated: Bool
    @Binding var isDismiss: Bool
    
    @State var ckViewModel = LoginViewModel.shared
    @State private var users: Set<String> = []
    
    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if !contactsVM.selectedContacts.isEmpty {
                            showMessage = true
                        }
                        users.insert(ckViewModel.preference!.userID)
                        vm.saveItem(categories: Array(newGroupVM.selectedCategory), activities: [], dates: [], users: users, owner: ckViewModel.preference!.userID)
                        newGroupCreated.toggle()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isDismiss.toggle()
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
