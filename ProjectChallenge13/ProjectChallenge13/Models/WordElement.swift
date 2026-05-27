//
//  WordElement.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI

/// Model that represents a single word in the word-cloud.
/// Keeps lightweight metadata used by the view and view-model.
struct WordElement: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let votos: Int
    /// Computed font size (points) used by the view. Can be set by the view model.
    var fontSize: CGFloat
    /// Deterministic seed used for stable pseudo-random placement or color selection.
    let seed: Int

    init(text: String, votos: Int, fontSize: CGFloat) {
        self.id = UUID()
        self.text = text
        self.votos = votos
        self.fontSize = fontSize
        self.seed = text.hashValue
    }

    /// Helper that maps votos in the range [minVotes, maxVotes] to a font size between
    /// `minFont` and `maxFont` using a power scaling function. The `exponent` controls
    /// how strongly larger vote counts are emphasized. If `exponent` > 1 the differences
    /// are amplified (recommended to highlight winners). If `exponent` < 1 differences
    /// are compressed. If minVotes == maxVotes the midpoint is returned.
    static func fontSize(for votos: Int, minVotes: Int, maxVotes: Int, minFont: CGFloat = 14, maxFont: CGFloat = 48, exponent: CGFloat = 1.25) -> CGFloat {
        guard maxVotes > minVotes else {
            return (minFont + maxFont) / 2
        }

        // normalized in [0, 1]
        let normalized = CGFloat(votos - minVotes) / CGFloat(maxVotes - minVotes)

        // apply power scaling to emphasize top entries
        let scaled = pow(normalized, exponent)

        return minFont + scaled * (maxFont - minFont)
    }
}
