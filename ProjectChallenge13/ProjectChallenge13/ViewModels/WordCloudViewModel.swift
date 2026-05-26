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
    nonisolated func calcPositions(canvasSize: CGSize, itemSizes: [CGSize]) -> [CGPoint]
}

struct DefaultWordCloudLayout: WordCloudLayouting {
    nonisolated func calcPositions(canvasSize: CGSize, itemSizes: [CGSize]) -> [CGPoint] {
        var positions = [CGPoint](repeating: .zero, count: itemSizes.count)
        guard canvasSize.width > 0 && canvasSize.height > 0 else { return positions }

        // Parameters to tune
        let maxIterPerItem = 5000
        let initialStep: CGFloat = 0.03
        let stepIncrementFactor: CGFloat = 1.0008 // slowly increase step to move faster outward

        // Spatial index bounds: coordinate system centered at (0,0)
        let halfW = canvasSize.width / 2
        let halfH = canvasSize.height / 2
        let bounds = CGRect(x: -halfW, y: -halfH, width: canvasSize.width, height: canvasSize.height)

        // Simple quadtree implementation for fast neighbor queries
        class QuadTree {
            let bounds: CGRect
            let capacity: Int
            var rects: [CGRect] = []
            var divided = false
            var nw: QuadTree?
            var ne: QuadTree?
            var sw: QuadTree?
            var se: QuadTree?

            init(bounds: CGRect, capacity: Int = 4) {
                self.bounds = bounds
                self.capacity = capacity
            }

            func insert(_ rect: CGRect) -> Bool {
                guard bounds.intersects(rect) else { return false }
                if !divided {
                    if rects.count < capacity {
                        rects.append(rect)
                        return true
                    } else {
                        subdivide()
                    }
                }
                if nw!.insert(rect) { return true }
                if ne!.insert(rect) { return true }
                if sw!.insert(rect) { return true }
                if se!.insert(rect) { return true }
                // As a fallback keep in this node
                rects.append(rect)
                return true
            }

            func query(in range: CGRect, found: inout [CGRect]) {
                if !bounds.intersects(range) { return }
                for r in rects { if r.intersects(range) { found.append(r) } }
                if !divided { return }
                nw!.query(in: range, found: &found)
                ne!.query(in: range, found: &found)
                sw!.query(in: range, found: &found)
                se!.query(in: range, found: &found)
            }

            private func subdivide() {
                let w = bounds.width / 2
                let h = bounds.height / 2
                let x = bounds.minX
                let y = bounds.minY
                nw = QuadTree(bounds: CGRect(x: x, y: y + h, width: w, height: h), capacity: capacity)
                ne = QuadTree(bounds: CGRect(x: x + w, y: y + h, width: w, height: h), capacity: capacity)
                sw = QuadTree(bounds: CGRect(x: x, y: y, width: w, height: h), capacity: capacity)
                se = QuadTree(bounds: CGRect(x: x + w, y: y, width: w, height: h), capacity: capacity)
                divided = true
            }
        }

        // Order indices by area descending, keep original index mapping
        let indices = Array(0..<itemSizes.count).sorted { (a, b) -> Bool in
            let areaA = itemSizes[a].width * itemSizes[a].height
            let areaB = itemSizes[b].width * itemSizes[b].height
            return areaA > areaB
        }

        var quad = QuadTree(bounds: bounds)
        var placedRects = [CGRect]()
        var fallbackStackOffset: CGFloat = 0

        let startPos = CGPoint(x: 0, y: 0)

        // local helpers to avoid actor-isolation issues when called from nonisolated context
        func rectCenter(_ r: CGRect) -> CGPoint {
            return CGPoint(x: r.origin.x + r.size.width / 2, y: r.origin.y + r.size.height / 2)
        }

        func isOutside(_ rect: CGRect) -> Bool {
            if rect.maxY > canvasSize.height / 2 { return true }
            if rect.minY < -canvasSize.height / 2 { return true }
            if rect.maxX > canvasSize.width / 2 { return true }
            if rect.minX < -canvasSize.width / 2 { return true }
            return false
        }

        for idx in indices {
            let itemSize = itemSizes[idx]
            // if item is larger than canvas, place centered (clamped)
            if itemSize.width >= canvasSize.width || itemSize.height >= canvasSize.height {
                let centered = CGRect(origin: CGPoint(x: startPos.x - itemSize.width / 2, y: startPos.y - itemSize.height / 2), size: itemSize)
                positions[idx] = rectCenter(centered)
                _ = quad.insert(centered)
                placedRects.append(centered)
                continue
            }

            var nextRect = CGRect(origin: CGPoint(x: startPos.x - itemSize.width / 2, y: startPos.y - itemSize.height / 2), size: itemSize)
            if !placedRects.isEmpty {
                var step: CGFloat = initialStep
                var iter = 0
                var placed = false
                while iter < maxIterPerItem {
                    // Query nearby rects to test intersection
                    var candidates: [CGRect] = []
                    quad.query(in: nextRect.insetBy(dx: -max(itemSize.width, itemSize.height), dy: -max(itemSize.width, itemSize.height)), found: &candidates)
                    var intersectsAny = false
                    for r in candidates {
                        if nextRect.intersects(r) { intersectsAny = true; break }
                    }
                    if !intersectsAny && !isOutside(nextRect) {
                        // place it
                        placed = true
                        break
                    }

                    // advance along spiral
                    nextRect.origin.x = startPos.x + (halfW * 0.01) * step * cos(step) + startPos.x - itemSize.width / 2
                    nextRect.origin.y = startPos.y + (halfH * 0.01) * step * sin(step) + startPos.y - itemSize.height / 2
                    step *= stepIncrementFactor
                    iter += 1
                }

                if !placed {
                    // fallback: stack along left edge inward
                    let x = -halfW + 4 + itemSize.width / 2
                    let y = -halfH + 4 + fallbackStackOffset + itemSize.height / 2
                    nextRect = CGRect(origin: CGPoint(x: x - itemSize.width / 2, y: y - itemSize.height / 2), size: itemSize)
                    fallbackStackOffset += itemSize.height + 4
                }
            }

            positions[idx] = rectCenter(nextRect)
            placedRects.append(nextRect)
            _ = quad.insert(nextRect)
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
        // Check both X and Y against the canvas centered at (0,0)
        if rect.maxY > canvasSize.height / 2 { return true }
        if rect.minY < -canvasSize.height / 2 { return true }
        if rect.maxX > canvasSize.width / 2 { return true }
        if rect.minX < -canvasSize.width / 2 { return true }
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
    private var computeTask: Task<Void, Never>? = nil

    init(words: [WordElement]? = nil, layout: WordCloudLayouting? = nil) {
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
        // Avoid computing until we have a valid canvas
        guard canvasSize.height > 0 && canvasSize.width > 0 else { return }

        // If inputs didn't change meaningfully, reuse cache synchronously
        if layoutCacheCanvasSize == canvasSize && simularWordSizes(a: layoutCacheWordSizes, b: wordSizes) {
            positions = layoutCachePositions
            return
        }

        // Cancel any in-flight computation to avoid piling work on the CPU/main thread
        computeTask?.cancel()

        // Capture the inputs we want to compute for
        let canvasCopy = canvasSize
        let sizesCopy = wordSizes
        let wordsCount = words.count
        let layoutRef = layout

        // Perform the potentially expensive layout off the main actor
        computeTask = Task.detached { [layoutRef] in
            // Respect cooperative cancellation
            if Task.isCancelled { return }

            let newPositions = layoutRef.calcPositions(canvasSize: canvasCopy, itemSizes: sizesCopy)

            // If cancelled after computing, don't try to publish results
            if Task.isCancelled { return }

            await MainActor.run {
                // Only apply results if the model hasn't changed meanwhile in a way that
                // would make these positions stale. We conservatively check canvas size and
                // that the sizes are similar.
                if self.layoutCacheCanvasSize == canvasCopy && self.simularWordSizes(a: self.layoutCacheWordSizes, b: sizesCopy) {
                    // Another task already set correct cache/results.
                    return
                }

                var finalPositions: [CGPoint]
                if newPositions.count == wordsCount {
                    finalPositions = newPositions
                } else if newPositions.count < wordsCount {
                    finalPositions = newPositions + Array(repeating: .zero, count: wordsCount - newPositions.count)
                } else {
                    finalPositions = Array(newPositions.prefix(wordsCount))
                }

                // Publish on main actor
                self.positions = finalPositions

                // Update caches
                self.layoutCacheCanvasSize = canvasCopy
                self.layoutCacheWordSizes = sizesCopy
                self.layoutCachePositions = finalPositions
            }
        }
    }

}
