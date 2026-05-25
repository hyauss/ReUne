//
//  ContactsViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation
import Contacts

@Observable
class ContactsViewModel {
    var selectedContacts: [CNContact] = []
    
    func removeContact(contact: CNContact) {
        selectedContacts.removeAll(where: { $0.identifier == contact.identifier })
    }
}
