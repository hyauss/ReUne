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
 
    init(item: ItemViewModel) {
        buildWords(from: item)
    }
 
    func buildWords(
        from item: ItemViewModel,
        maxWords: Int = 10,
        minFont:  CGFloat = 14,
        maxFont:  CGFloat = 48
    ) {
        // 1. Aggregate votes by name.
        var agg: [String: Int] = [:]
        for a in item.actitivies {
            agg[a.name, default: 0] += a.votos
        }
 
        // 2. Only keep activities with at least 1 vote.
        let filtered = agg.filter { $0.value > 0 }
        guard !filtered.isEmpty else {
            DispatchQueue.main.async { self.words = [] }
            return
        }
 
        // 3. Sort: descending votes, then alphabetically for a stable tie-break.
        let sorted = filtered.sorted {
            $0.value != $1.value ? $0.value > $1.value : $0.key < $1.key
        }
        let top = Array(sorted.prefix(maxWords))
 
        let maxVotes = top.first?.value ?? 1
        let minVotes = top.last?.value  ?? 1
 
        // 4. Build elements.
        //    When all votes are equal every word gets minFont so they're all
        //    the same small size
        let elements: [WordElement] = top.map { name, votos in
            let font: CGFloat
            if maxVotes == minVotes {
                font = minFont
            } else {
                let t = CGFloat(votos - minVotes) / CGFloat(maxVotes - minVotes)
                font = minFont + t * (maxFont - minFont)
            }
            return WordElement(
                text:     name,
                votos:    votos,
                fontSize: font,
                isWinner: votos == maxVotes
            )
        }
 
        DispatchQueue.main.async { self.words = elements }
    }
}
