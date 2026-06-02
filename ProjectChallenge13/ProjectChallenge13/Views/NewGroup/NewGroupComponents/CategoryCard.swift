//
//  CategoryCard.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 23/05/26.
//

import SwiftUI

/// A card that displays a category name with a rounded pill shape.
struct CategoryCard: View {
    /// The category to display.
    var category: CategoryModel
    
    var body: some View {
        HStack {
            Text(category.name)
                .foregroundStyle(.formCardText)
                .padding(.horizontal, 22)
                .padding(.vertical, 5)
                .background(.formCardBack)
                .clipShape(RoundedRectangle(cornerRadius: 90))
                .padding(.leading, 48)
            Spacer()
        }
    }
}
