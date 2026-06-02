//
//  ContactsView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.

import SwiftUI
import ContactsUI

/// A view that allows the user to add contacts via a contact picker sheet.
struct ContactsView: View {
    /// Controls the visibility of the contact picker sheet.
    @State private var showPicker = false

    var body: some View {
        VStack {
            Button {
                showPicker = true
            } label: {
                PlusButton()
                    .padding(.leading, 48)
                    .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $showPicker) {
            ContactPickerView()
        }
    }
}
