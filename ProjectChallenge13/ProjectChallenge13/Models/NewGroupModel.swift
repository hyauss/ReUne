//
//  NewGroupModel.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import Foundation

/// Model for the new group
///  - Parameter meetingCategories: Array of CategoryModel of possible categories for the enconter
struct NewGroupModel {
    let meetingCategories: [CategoryModel] = [
        CategoryModel(name: "Ao ar livre"),
        CategoryModel(name: "Bem-estar"),
        CategoryModel(name: "Criatividade"),
        CategoryModel(name: "Cultura e Entretenimento"),
        CategoryModel(name: "Esportes"),
        CategoryModel(name: "Festas"),
        CategoryModel(name: "Festividades"),
        CategoryModel(name: "Gastronomia"),
        CategoryModel(name: "Viagem"),
        CategoryModel(name: "Outros")
    ]
}
