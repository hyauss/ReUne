//
//  CategoriesMenu.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

struct CategoriesMenu: View {
    @Binding var selectedCategory: Set<String>
    var viewModel = NewGroupViewModel()

    var body: some View {
        Menu () {
            Section("Categorias") {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button {
                        if selectedCategory.contains(category) {
                            selectedCategory.remove(category)
                        }
                        else {
                            selectedCategory.insert(category)
                        }
                    } label: {
                        Text(category)
                        if selectedCategory.contains(category) {
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
        .padding(.bottom)    }
}
