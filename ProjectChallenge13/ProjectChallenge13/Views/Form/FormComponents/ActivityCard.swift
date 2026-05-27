//
//  ActivityCard.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 26/05/26.
//

import SwiftUI

struct ActivityCard: View {
    var activity: ActivitiesModel
    
    var body: some View {
        Text(activity.name)
            .foregroundStyle(.newGroupCategoriesText)
            .padding(.horizontal, 22)
            .padding(.vertical, 5)
            .background(.newGroupCategoriesBackground)
            .clipShape(RoundedRectangle(cornerRadius: 90))
            //.padding(.leading, 48)
    }
}

//#Preview {
//    ActivityCard()
//}
