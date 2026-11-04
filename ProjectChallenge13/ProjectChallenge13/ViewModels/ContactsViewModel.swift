//
//  ContactsViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation
import Contacts

/// ViewModel for the contacts
@Observable
class ContactsViewModel {
    
    /// Array of CNContact, of the contacts that the user had selected
    var selectedContacts: [CNContact] = []
    
    /// Removes a contact from the selected contacts list.
    /// - Parameter contact: The contact to be removed.
    func removeContact(contact: CNContact) {
        selectedContacts.removeAll(where: { $0.identifier == contact.identifier })
    }
}
