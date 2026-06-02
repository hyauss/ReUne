//
//  ContactsView.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.

import SwiftUI
import ContactsUI
import Aptabase

struct ContactsView: View {
    @State private var showPicker = false

    var body: some View {
        VStack {
            Button {
                Aptabase.shared.trackEvent("participant_add_tapped") //Avarage of people per group
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
