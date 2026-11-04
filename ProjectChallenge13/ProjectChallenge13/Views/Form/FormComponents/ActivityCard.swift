//
//  ActivityCard.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import SwiftUI

/// A card that displays an activity name with a rounded pill shape.
struct ActivityCard: View {
    /// The activity to display.
    var activity: ActivitiesModel
    
    var body: some View {
        Text(activity.name)
            .foregroundStyle(.formCardText)
            .padding(.horizontal, 22)
            .padding(.vertical, 5)
            .background(.formCardBack)
            .clipShape(RoundedRectangle(cornerRadius: 90))
    }
}
