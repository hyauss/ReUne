//
//  NewGroupViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation

@Observable
class NewGroupViewModel {
    let newGroupModel = NewGroupModel()
    var categories: [CategoryModel]
    var selectedCategory: Set<CategoryModel> = []
    
    
    init() {
        self.categories = newGroupModel.meetingCategories
    }
    
    func removeCategory(category: CategoryModel) {
        self.selectedCategory.remove(category)
    }
    
    func addCategory(category: CategoryModel) {
        self.selectedCategory.insert(category)
    }
}
