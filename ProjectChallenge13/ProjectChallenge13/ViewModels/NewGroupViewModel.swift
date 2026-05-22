//
//  NewGroupViewModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation

struct NewGroupViewModel {
    let newGroupModel = NewGroupModel()
    let categories: [String]
    
    init() {
        self.categories = newGroupModel.meetingCategories
    }
}
