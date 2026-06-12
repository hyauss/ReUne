//
//  ContactsView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.

import SwiftUI
import ContactsUI
import Aptabase

/// A view that allows the user to add contacts via a contact picker sheet.
struct ContactsView: View {
    /// Controls the visibility of the contact picker sheet.
    @State private var showPicker = false

    var body: some View {
        VStack {
            Button {
                Aptabase.shared.trackEvent("participant_add_tapped") //Avarage of people per group
                showPicker = true
            } label: {
                PlusButton()
                    .padding(.leading, 29)
                    .padding(.top)
                    .padding(.bottom)
            }
        }
        .sheet(isPresented: $showPicker) {
            ContactPickerView()
        }
    }
}
