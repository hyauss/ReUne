//
//  NewGroupViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation
import CloudKit

/// ViewModel that manages the creation of a new group
@Observable
class NewGroupViewModel {
    /// The data source containing all available categories.
    let newGroupModel = NewGroupModel()
    /// All available categories loaded from ``NewGroupModel``.
    var categories: [CategoryModel]
    /// Categories selected by the user for the new group.
    var selectedCategory: Set<CategoryModel> = []
    /// The CloudKit record of the created group.
    var record: CKRecord?
    
    init() {
        self.categories = newGroupModel.meetingCategories
    }
    
    /// Removes a category from the selected categories.
    /// - Parameter category: The category to be removed.
    func removeCategory(category: CategoryModel) {
        self.selectedCategory.remove(category)
    }
    
    /// Adds a category to the selected categories.
    /// - Parameter category: The category to be added.
    func addCategory(category: CategoryModel) {
        self.selectedCategory.insert(category)
    }
}
