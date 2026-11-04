//
//  WordElement.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI

/// Model that represents a single word in the word-cloud.
struct WordElement: Identifiable, Hashable, Codable {
    let id:       UUID
    let text:     String
    let votos:    Int
    var fontSize: CGFloat
    var isWinner: Bool
    let seed:     Int
 
    init(text: String, votos: Int, fontSize: CGFloat, isWinner: Bool = false) {
        self.id       = UUID()
        self.text     = text
        self.votos    = votos
        self.fontSize = fontSize
        self.isWinner = isWinner
        self.seed     = text.hashValue
    }
}
