//
//  ContactPickerView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//  Built with AI assistance

import ContactsUI
import SwiftUI

/// A SwiftUI wrapper for `CNContactPickerViewController` that allows the user to select contacts.
struct ContactPickerView: UIViewControllerRepresentable {
    /// The view model that manages the selected contacts.
    @Environment(ContactsViewModel.self) private var contactsVM
    
    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.predicateForEnablingContact = NSPredicate(value: true)
        return picker
    }
    
    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: contactsVM)
    }
    
    /// Coordinator that handles contact picker delegate callbacks.
    class Coordinator: NSObject, CNContactPickerDelegate {
        /// The view model used to store selected contacts.
        var viewModel: ContactsViewModel
        
        /// - Parameter viewModel: The view model to update when contacts are selected.
        init(viewModel: ContactsViewModel) {
            self.viewModel = viewModel
        }
        
        /// Called when the user finishes selecting contacts.
        /// - Parameter contacts: The contacts selected by the user.
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            let novos = contacts.filter { novo in
                !viewModel.selectedContacts.contains(where: { $0.identifier == novo.identifier })
            }
            viewModel.selectedContacts += novos
        }
    }
}
