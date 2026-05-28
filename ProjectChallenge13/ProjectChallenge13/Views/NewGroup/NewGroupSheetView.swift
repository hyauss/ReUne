//
//  NewGroupSheetView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI
import ContactsUI
import CloudKit

struct NewGroupSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var contactsVM = ContactsViewModel()
    @State var newGroupVM = NewGroupViewModel()
    @State var showMessage = false
    @State var isDismiss: Bool = false
    @State var isDismissNotSave: Bool = false
    @Binding var formRecord: CKRecord
    @Binding var newGroupCreated: Bool
    
    var phoneNumbers: [String] {
        contactsVM.selectedContacts.compactMap {
            $0.phoneNumbers.first?.value.stringValue
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Adicione participante no seu grupo")
                    .padding(.leading, 29)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(contactsVM.selectedContacts, id: \.identifier) { contact in
                            ContactCard(contact: contact)
                                .environment(contactsVM)
                        }
                    }
                    .padding(.leading, 29)
                }
                
                ContactsView()
                    .environment(contactsVM)
                
                Text("Quais categorias você gostaria de adicionar?")
                    .padding(.leading, 29)
                
                CategoriesMenu()
                    .environment(newGroupVM)
                
                ScrollView(showsIndicators: false) {
                    
                    ForEach(Array(newGroupVM.selectedCategory), id: \.self) { category in
                        CategoryCard(category: category)
                    }
                }
                
                Spacer()
                
                NewGroupToolbar(showMessage: $showMessage, isDismiss: $isDismiss, isDismissNotSave: $isDismissNotSave)
                    .environment(contactsVM)
                    .environment(newGroupVM)
                    .sheet(isPresented: $showMessage, onDismiss: {
                        isDismiss.toggle()
                    }) {
                        let url = URL(string: "challenge13://\(newGroupVM.record!.recordID.recordName)")
                        MessageView(recipients: phoneNumbers, body: "Confira esse link: \(String(describing: url?.absoluteString))")
                    }
            }
            .onChange(of: isDismiss) {
                formRecord = newGroupVM.record!
                newGroupCreated.toggle()
                dismiss()
            }
            .onChange(of: isDismissNotSave) {
                dismiss()
            }
        }
    }
}
 
