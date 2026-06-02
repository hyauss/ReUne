//
//  CategoriesMenu.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

/// A menu that displays available categories for the user to select or deselect.
struct CategoriesMenu: View {
    /// The view model that manages the selected categories.
    @Environment(NewGroupViewModel.self) var newGroupVM

    var body: some View {
        Menu() {
            Section("Categorias") {
                ForEach(newGroupVM.categories, id: \.self) { category in
                    Button {
                        if newGroupVM.selectedCategory.contains(category) {
                            newGroupVM.removeCategory(category: category)
                        }
                        else {
                            newGroupVM.addCategory(category: CategoryModel(name: category.name))
                        }
                    } label: {
                        Text(category.name)
                        if newGroupVM.selectedCategory.contains(category) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            PlusButton()
                .padding(.leading, 48)
                .padding(.top)
        }
        .menuActionDismissBehavior(.disabled)
        .padding(.bottom)
    }
}
