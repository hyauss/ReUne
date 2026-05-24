//
//  ContactPickerView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//  Built with AI assistance

import ContactsUI
import SwiftUI

struct ContactPickerView: UIViewControllerRepresentable {
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
    
    class Coordinator: NSObject, CNContactPickerDelegate {
        var viewModel: ContactsViewModel
        
        init(viewModel: ContactsViewModel) {
            self.viewModel = viewModel
        }
        
        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            let novos = contacts.filter { novo in
                !viewModel.selectedContacts.contains(where: { $0.identifier == novo.identifier })
            }
            viewModel.selectedContacts += novos
        }
    }
}
