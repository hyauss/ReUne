//
//  NewGroupToolbar.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

struct NewGroupToolbar: View {
    @Environment(ContactsViewModel.self) private var contactsVM
    @Binding var showMessage: Bool
    
    var body: some View {
        Text("")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if !contactsVM.selectedContacts.isEmpty {
                            showMessage = true
                        }
                        
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        
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
