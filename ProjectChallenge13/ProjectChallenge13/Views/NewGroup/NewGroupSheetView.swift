//
//  NewGroupSheetView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI
import ContactsUI

struct NewGroupSheetView: View {
    @State var selectedCategory: Set<String> = []
    @State var showMessage = false
    @State var contactsVM = ContactsViewModel()
    
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
                
                CategoriesMenu(selectedCategory: $selectedCategory)
                
                ForEach(Array(selectedCategory), id: \.self) { category in
                    CategoryCard(category: category)
                }
                
                Spacer()
                
                NewGroupToolbar(showMessage: $showMessage)
                    .environment(contactsVM)
                    .sheet(isPresented: $showMessage) {
                        MessageView(
                            recipients: phoneNumbers,
                            body: "Confira esse link: https://seuapp.com"
                        )
                    }
            }
        }
    }
}

#Preview {
    NewGroupSheetView(selectedCategory: [])
}
