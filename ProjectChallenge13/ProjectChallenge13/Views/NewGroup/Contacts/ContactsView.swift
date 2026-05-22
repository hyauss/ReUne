//
//  ContactsView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI
import ContactsUI

struct ContactsView: View {
    @State private var showPicker = false
    @State private var showMessage = false
    @State private var selectedContacts: [CNContact] = []

    var phoneNumbers: [String] {
        selectedContacts.compactMap {
            $0.phoneNumbers.first?.value.stringValue
        }
    }

    var body: some View {
        VStack {
            Button("Selecionar contatos") {
                showPicker = true
            }

            if !selectedContacts.isEmpty {
                List(selectedContacts, id: \.identifier) { contact in
                    HStack {
                        // Foto do contato
                        if let imageData = contact.thumbnailImageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                        }

                        Text("\(contact.givenName) \(contact.familyName)")
                    }
                }

                Button("Enviar link") {
                    showMessage = true
                }
            }
        }
        .sheet(isPresented: $showPicker) {
            ContactPickerView(selectedContacts: $selectedContacts)
        }
        .sheet(isPresented: $showMessage) {
            MessageView(
                recipients: phoneNumbers,
                body: "Confira esse link: https://seuapp.com"
            )
        }
    }
}

#Preview {
    ContactsView()
}
