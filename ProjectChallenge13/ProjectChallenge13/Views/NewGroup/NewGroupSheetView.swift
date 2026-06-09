//
//  NewGroupSheetView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI
import ContactsUI
import CloudKit

/// A sheet view for creating a new group, allowing the user to add contacts and categories.
struct NewGroupSheetView: View {
    /// The dismiss action used to close the sheet.
    @Environment(\.dismiss) private var dismiss

    /// The view model that manages the selected contacts.
    @State var contactsVM = ContactsViewModel()
    /// The view model that manages the new group data.
    @State var newGroupVM = NewGroupViewModel()
    /// Controls the visibility of the message sheet.
    @State var showMessage = false
    /// Triggers dismissal after successfully saving the group.
    @State var isDismiss: Bool = false
    /// Triggers dismissal without saving the group.
    @State var isDismissNotSave: Bool = false

    /// The CloudKit record of the created group, passed back to the parent view.
    @Binding var formRecord: CKRecord
    /// Triggers a refresh in the parent view when a new group is created.
    @Binding var newGroupCreated: Bool

    /// The phone numbers extracted from the selected contacts.
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
                    .foregroundStyle(.formMainText)
                
                HStack (spacing: 20) {
                    ContactsView()
                        .environment(contactsVM)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(contactsVM.selectedContacts, id: \.identifier) { contact in
                                ContactCard(contact: contact)
                                    .environment(contactsVM)
                            }
                        }
                        .padding(.trailing, 16)
                    }
                }
                
                
                Text("Quais categorias você gostaria de adicionar?")
                    .padding(.leading, 29)
                    .foregroundStyle(.formMainText)
                
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
                        let url = URL(string: "ReUne://\(newGroupVM.record!.recordID.recordName)")
                        if let url = url {
                            MessageView(recipients: phoneNumbers, body: "Confira esse link: \(url.absoluteString)")
                        }
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
        .background(.formBackgroud)
    }
}
 
