//
//  ActivityMenu.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import SwiftUI

struct ActivityMenu: View {
    @Environment(FormViewModel.self) var formVM

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


