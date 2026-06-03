//
//  ActivityMenu.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import SwiftUI

/// A menu that displays a list of activities for the user to select or deselect.
struct ActivityMenu: View {
    /// The form view model that manages selected activities.
    @Environment(FormViewModel.self) var formVM
    /// The list of activities displayed in the menu.
    @State var activities: [ActivitiesModel]

    var body: some View {
        Menu() {
            Section("Atividades") {
                ForEach(activities, id: \.self) { activity in
                    Button {
                        if formVM.selectedActivities.contains(activity) {
                            formVM.removeActivity(activity: activity)
                        }
                        else {
                            formVM.addCategory(activity: activity)
                        }
                    } label: {
                        Text(activity.name)
                        if formVM.selectedActivities.contains(activity) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            PlusButton()
                .padding(.bottom)
        }
        .menuActionDismissBehavior(.disabled)
    }
}
