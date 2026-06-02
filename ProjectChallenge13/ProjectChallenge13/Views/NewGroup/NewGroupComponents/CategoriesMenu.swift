//
//  CategoriesMenu.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI
import Aptabase

struct CategoriesMenu: View {
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
                            Aptabase.shared.trackEvent("category_selected", with: [ "category_name": category.name]) // most frequent category
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
