//
//  NewGroupToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

struct NewGroupToolbar: View {
    /// The view model that manages the selected contacts.
    @Environment(ContactsViewModel.self) private var contactsVM
    /// The view model that manages the new group data.
    @Environment(NewGroupViewModel.self) var newGroupVM

    /// The shared group view model used to save the new group to CloudKit.
    @StateObject private var vm = GroupViewModel.shared

    /// Triggers the message sheet to share the group with selected contacts.
    @Binding var showMessage: Bool
    /// Triggers dismissal after successfully saving the group.
    @Binding var isDismiss: Bool
    /// Triggers dismissal without saving the group.
    @Binding var isDismissNotSave: Bool

    /// The login view model used to retrieve the current user's ID.
    @State var ckViewModel = LoginViewModel.shared
    /// The set of user IDs to be added to the group.
    @State private var users: Set<String> = []
    
    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    if !newGroupVM.selectedCategory.isEmpty {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color.white)
                            .frame(width: 20, height: 20)
                            .circularProgressButton {
                                users.insert(ckViewModel.preference!.userID)
                                newGroupVM.record = vm.saveItem(categories: Array(newGroupVM.selectedCategory), activities: [ActivitiesModel(name: "", votos: 0)], dates: [], users: users, owner: ckViewModel.preference!.userID)
                                
                                if !contactsVM.selectedContacts.isEmpty {
                                    showMessage = true
                                } else {
                                    isDismiss.toggle()
                                }
                            }
                        .scaleEffect(0.9)
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
