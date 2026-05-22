//
//  ContactPickerView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import ContactsUI
import SwiftUI

struct ContactPickerView: UIViewControllerRepresentable {
    @Binding var selectedContacts: [CNContact]

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.predicateForEnablingContact = NSPredicate(value: true)
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedContacts: $selectedContacts)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        @Binding var selectedContacts: [CNContact]

        init(selectedContacts: Binding<[CNContact]>) {
            _selectedContacts = selectedContacts
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            selectedContacts = contacts
        }
    }
}
