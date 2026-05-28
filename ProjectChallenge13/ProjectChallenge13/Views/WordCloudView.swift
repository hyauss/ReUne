//
//  WordCloudView.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI
import UIKit

struct WordCloudView: View {
    @StateObject private var viewModel: WordCloudViewModel
 
    // Available width captured once by a hidden GeometryReader.
    @State private var availableWidth: CGFloat = 0
    // Layout result computed from words + availableWidth.
    @State private var layout: LayoutResult = LayoutResult(positions: [], requiredHeight: 140)
 
    init(group: ItemViewModel) {
        _viewModel = StateObject(wrappedValue: WordCloudViewModel(item: group))
    }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.words.isEmpty {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(height: 140)
                    .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 6)
                    .overlay(
                        Text("Nenhuma atividade com votos ainda")
                            .foregroundColor(Color.ultramarineBlue)
                    )
                    .padding(.horizontal)
            } else {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 6)
 
                    ForEach(Array(zip(viewModel.words, layout.positions)), id: \.0.id) { word, pos in
                        Text(word.text)
                            .font(.system(size: word.fontSize, weight: .semibold))
                            .foregroundColor(
                                word.id == viewModel.words.first?.id ? Color.nightBlue : Color.ultramarineBlue
                            )
                            .fixedSize()
                            .position(pos)
                            .accessibilityLabel("\(word.text), \(word.votos) votes")
                    }
                }
                .frame(height: layout.requiredHeight)
                .padding(.horizontal)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                availableWidth = geo.size.width
                                recalculate()
                            }
                            .onChange(of: geo.size.width) { newWidth in
                                availableWidth = newWidth
                                recalculate()
                            }
                    }
                )
            }
        }
        .onChange(of: viewModel.words) { _ in
            recalculate()
        }
    }
 
    private func recalculate() {
        guard availableWidth > 0 else { return }
        layout = computeLayout(for: viewModel.words, width: availableWidth)
    }
 
    // MARK: - Layout
 
    struct LayoutResult: Equatable {
        let positions: [CGPoint]
        let requiredHeight: CGFloat
    }
 
    /// Measures each word, then places them using an Archimedean spiral.
    /// The canvas grows vertically until every word fits, so `requiredHeight`
    /// always reflects the true space needed
    func computeLayout(for words: [WordElement], width: CGFloat) -> LayoutResult {
        guard !words.isEmpty, width > 0 else {
            return LayoutResult(positions: [], requiredHeight: 140)
        }
 
        let padding: CGFloat = 2
        let edgePadding: CGFloat = 24
        let minHeight: CGFloat = 140
 
        // Measure all words up-front with UIKit for accurate bounding boxes.
        let sizes: [CGSize] = words.map { word in
            let font = UIFont.systemFont(ofSize: word.fontSize, weight: .semibold)
            let size = (word.text as NSString).size(withAttributes: [.font: font])
            return CGSize(width: ceil(size.width) + 4, height: ceil(size.height))
        }
 
        // Start with a canvas tall enough to hold the tallest word twice,
        // then grow until every word is placed without overlap.
        var canvasHeight = max(minHeight, (sizes.map(\.height).max() ?? 0) * 2)
 
        for _ in 0..<12 {
            let result = place(
                words: words,
                sizes: sizes,
                canvasWidth: width,
                canvasHeight: canvasHeight,
                padding: padding,
                edgePadding: edgePadding
            )
 
            guard result.allPlaced else {
                canvasHeight *= 1.4
                continue
            }
 
            // Compute the real bounding box of placed words (both axes).
            let topEdge = result.positions
                .enumerated()
                .map { idx, pos in pos.y - sizes[idx].height / 2 - padding }
                .min() ?? 0
 
            let bottomEdge = result.positions
                .enumerated()
                .map { idx, pos in pos.y + sizes[idx].height / 2 + padding }
                .max() ?? canvasHeight
 
            let leftEdge = result.positions
                .enumerated()
                .map { idx, pos in pos.x - sizes[idx].width / 2 - padding }
                .min() ?? 0
 
            let rightEdge = result.positions
                .enumerated()
                .map { idx, pos in pos.x + sizes[idx].width / 2 + padding }
                .max() ?? width
 
            // Shift positions so content is centred both vertically and
            // horizontally inside the rectangle, respecting edgePadding on all sides.
            let contentHeight = bottomEdge - topEdge
            let contentWidth  = rightEdge - leftEdge
 
            let finalHeight = max(minHeight, contentHeight + edgePadding * 2)
 
            let verticalShift   = edgePadding - topEdge
            let horizontalShift = (width - contentWidth) / 2 - leftEdge
 
            let centeredPositions = result.positions.map {
                CGPoint(x: $0.x + horizontalShift, y: $0.y + verticalShift)
            }
 
            return LayoutResult(positions: centeredPositions, requiredHeight: finalHeight)
        }
 
        // Fallback: centre everything if all attempts failed.
        return LayoutResult(
            positions: words.map { _ in CGPoint(x: width / 2, y: canvasHeight / 2) },
            requiredHeight: canvasHeight
        )
    }
 
    // MARK: - Placement
 
    private struct PlacementResult {
        let positions: [CGPoint]
        let allPlaced: Bool
    }
 
    private func place(
        words: [WordElement],
        sizes: [CGSize],
        canvasWidth: CGFloat,
        canvasHeight: CGFloat,
        padding: CGFloat,
        edgePadding: CGFloat
    ) -> PlacementResult {
 
        var placedRects: [CGRect] = []
        var positions: [CGPoint] = []
        var allPlaced = true
 
        let center = CGPoint(x: canvasWidth / 2, y: canvasHeight / 2)
        let bounds = CGRect(
            x: edgePadding,
            y: edgePadding,
            width: canvasWidth - edgePadding * 2,
            height: canvasHeight - edgePadding * 2
        )
 
        for (idx, word) in words.enumerated() {
            let size = sizes[idx]
            let halfW = size.width / 2 + padding
            let halfH = size.height / 2 + padding
 
            var placed = false
 
            let angleStep: CGFloat = 0.25
            let radiusStep: CGFloat = 1.5
            let maxSteps = 2000
            let startAngle = CGFloat(abs(word.seed) % 628) / 100.0
 
            for step in 0..<maxSteps {
                let t = CGFloat(step)
                let angle = startAngle + t * angleStep
                let radius = t * radiusStep
 
                let cx = center.x + cos(angle) * radius
                let cy = center.y + sin(angle) * radius
 
                let rect = CGRect(
                    x: cx - halfW,
                    y: cy - halfH,
                    width: halfW * 2,
                    height: halfH * 2
                )
 
                guard bounds.contains(rect) else { continue }
 
                if placedRects.allSatisfy({ !$0.intersects(rect) }) {
                    placedRects.append(rect)
                    positions.append(CGPoint(x: cx, y: cy))
                    placed = true
                    break
                }
            }
 
            if !placed {
                allPlaced = false
                positions.append(center)
            }
        }
 
        return PlacementResult(positions: positions, allPlaced: allPlaced)
    }
}
