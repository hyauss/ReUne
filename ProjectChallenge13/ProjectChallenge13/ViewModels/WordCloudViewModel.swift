//
//  WordCloudViewModel.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI
import Combine

/// ViewModel responsible for transforming `ItemViewModel.actitivies` into
/// a small list of `WordElement` suitable for rendering in a word cloud.
final class WordCloudViewModel: ObservableObject {
    @Published private(set) var words: [WordElement] = []

    /// Create a view model from an `ItemViewModel` and build the top words.
    init(item: ItemViewModel) {
        buildWords(from: item)
    }

    /// Rebuilds the words from the provided item.
    func buildWords(from item: ItemViewModel, maxWords: Int = 10, minFont: CGFloat = 14, maxFont: CGFloat = 48) {
        let activities = item.actitivies

        // Aggregate activities by name (in case there are duplicates), summing votos.
        var agg: [String: Int] = [:]
        for a in activities {
            agg[a.name, default: 0] += a.votos
        }

        // Keep only activities with votos > 0
        let filtered = agg.filter { $0.value > 0 }

        guard !filtered.isEmpty else {
            DispatchQueue.main.async {
                self.words = []
            }
            return
        }

        // Sort by votos desc and take top `maxWords`
        let top = filtered.sorted { $0.value > $1.value }.prefix(maxWords)

        let votosArray = top.map { $0.value }
        let minVotes = votosArray.min() ?? 0
        let maxVotes = votosArray.max() ?? 0

        let elements: [WordElement] = top.map { (name, votos) in
            // use power scaling to emphasize the top-voted activity
            let font = WordElement.fontSize(for: votos, minVotes: minVotes, maxVotes: maxVotes, minFont: minFont, maxFont: maxFont, exponent: 1.25)
            return WordElement(text: name, votos: votos, fontSize: font)
        }

        DispatchQueue.main.async {
            self.words = elements
        }
    }
}
