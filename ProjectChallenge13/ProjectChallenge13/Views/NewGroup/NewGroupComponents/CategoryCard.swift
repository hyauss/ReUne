//
//  CategoryCard.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 23/05/26.
//

import SwiftUI

struct CategoryCard: View {
    var category: CategoryModel
    var body: some View {
        Text(category.name)
            .foregroundStyle(.newGroupCategoriesText)
            .padding(.horizontal, 22)
            .padding(.vertical, 5)
            .background(.newGroupCategoriesBackground)
            .clipShape(RoundedRectangle(cornerRadius: 90))
            .padding(.leading, 48)    }
}
