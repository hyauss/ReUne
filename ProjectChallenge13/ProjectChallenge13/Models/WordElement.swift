//
//  WordElement.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI

struct WordElement: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let color: Color
    let fontSize: CGFloat
}

