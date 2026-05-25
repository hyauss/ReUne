//
//  WordCloudViewModel.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI
import Combine
import CoreGraphics

protocol WordCloudLayouting {
    func calcPositions(canvasSize: CGSize, itemSizes: [CGSize]) -> [CGPoint]
}

struct DefaultWordCloudLayout: WordCloudLayouting {
    func calcPositions(canvasSize: CGSize, itemSizes: [CGSize]) -> [CGPoint] {
        var positions = [CGPoint](repeating: .zero, count: itemSizes.count)
        if canvasSize.height == 0 {
            return positions
        }

        var rects = [CGRect]()
        var step: CGFloat = 0
        let ratio = canvasSize.width * 1.5 / canvasSize.height
        let startPos = CGPoint(x: 0, y: 0)

        for (index, itemSize) in itemSizes.enumerated() {
            var nextRect = CGRect(
                origin: CGPoint(
                    x: startPos.x - itemSize.width / 2,
                    y: startPos.y - itemSize.height / 2
                ),
                size: itemSize
            )
            if index > 0 {
                while checkIntersects(rect: nextRect, rects: rects) || checkOutsideBoundary(canvasSize: canvasSize, rect: nextRect) {
                    nextRect.origin.x = startPos.x + ratio * step * cos(step) + startPos.x - itemSize.width / 2
                    nextRect.origin.y = startPos.y + ratio * step * sin(step) + startPos.y - itemSize.height / 2
                    step += 0.01
                }
            }

            positions[index] = nextRect.center
            rects.append(nextRect)
        }
        return positions
    }

    private func checkIntersects(rect: CGRect, rects: [CGRect]) -> Bool {
        for r in rects {
            if rect.intersects(r) {
                return true
            }
        }
        return false
    }

    private func checkOutsideBoundary(canvasSize: CGSize, rect: CGRect) -> Bool {
        if rect.maxY > canvasSize.height / 2 {
            return true
        }
        if rect.minY < -canvasSize.height / 2 {
            return true
        }
        return false
    }
}


@MainActor
final class WordCloudViewModel: ObservableObject {
    @Published var words: [WordElement]
    @Published var wordSizes: [CGSize] {
        didSet { recomputePositionsIfNeeded() }
    }
    @Published var canvasSize: CGSize = .zero
    @Published private(set) var positions: [CGPoint] = []

    private let layout: WordCloudLayouting
    private var layoutCacheCanvasSize: CGSize = .zero
    private var layoutCacheWordSizes: [CGSize] = []
    private var layoutCachePositions: [CGPoint] = []

    init(words: [WordElement]? = nil, layout: WordCloudLayouting? = nil) {
        // In production default to no sample words — view should show a placeholder when empty.
        let initialWords = words ?? []
        self.words = initialWords
        self.wordSizes = Array(repeating: .zero, count: initialWords.count)
        self.layout = layout ?? DefaultWordCloudLayout()
    }

    func setActivities(_ activities: [ActivitiesModel]) {
        let filtered = activities.filter { $0.votos > 0 }
        guard !filtered.isEmpty else {
            words = []
            wordSizes = []
            positions = []
            return
        }

        let maxVotes = filtered.map { $0.votos }.max() ?? 1
        let minFont: CGFloat = 16
        let maxFont: CGFloat = 48
        let highlightColor = Color.blue
        let normalColor = Color.black

        let elements: [WordElement] = filtered.map { activity in
            let normalized = maxVotes > 0 ? CGFloat(activity.votos) / CGFloat(maxVotes) : 0
            let fontSize = minFont + normalized * (maxFont - minFont)
            let color: Color = (activity.votos == maxVotes && maxVotes > 0) ? highlightColor : normalColor
            return WordElement(text: activity.name, color: color, fontSize: fontSize)
        }

        words = elements
        wordSizes = Array(repeating: .zero, count: elements.count)
        recomputePositionsIfNeeded()
    }

    func setGroup(_ group: ItemViewModel) {
        setActivities(group.actitivies)
    }

    func updateSize(_ size: CGSize, at index: Int) {
        guard index >= 0 && index < wordSizes.count else { return }
        if wordSizes[index] != size {
            wordSizes[index] = size
            recomputePositionsIfNeeded()
        }
    }

    func updateCanvasSize(_ size: CGSize) {
        if canvasSize != size {
            canvasSize = size
            recomputePositionsIfNeeded()
        }
    }

    private func simularWordSizes(a: [CGSize], b: [CGSize]) -> Bool {
        if a == b { return true }
        if a.count != b.count { return false }
        var diff: CGFloat = 0
        for i in 0..<a.count {
            diff += abs(a[i].width - b[i].width) + abs(a[i].height - b[i].height)
        }
        return diff < 1.0
    }

    private func recomputePositionsIfNeeded() {
        guard canvasSize.height > 0 else { return }

        if layoutCacheCanvasSize == canvasSize && simularWordSizes(a: layoutCacheWordSizes, b: wordSizes) {
            positions = layoutCachePositions
            return
        }

        let newPositions = layout.calcPositions(canvasSize: canvasSize, itemSizes: wordSizes)
        if newPositions.count == words.count {
            positions = newPositions
        } else if newPositions.count < words.count {
            positions = newPositions + Array(repeating: .zero, count: words.count - newPositions.count)
        } else {
            positions = Array(newPositions.prefix(words.count))
        }

        layoutCacheCanvasSize = canvasSize
        layoutCacheWordSizes = wordSizes
        layoutCachePositions = positions
    }

}
