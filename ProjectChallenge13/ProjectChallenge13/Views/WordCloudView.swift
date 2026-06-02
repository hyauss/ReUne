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
 
    @State private var availableWidth: CGFloat = 0
    @State private var layout: CloudLayout = .empty
 
    init(group: ItemViewModel) {
        _viewModel = StateObject(wrappedValue: WordCloudViewModel(item: group))
    }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if viewModel.words.isEmpty {
                emptyState
            } else {
                cloud
            }
        }
        .onChange(of: viewModel.words) { _ in recalculate() }
    }
 
    private var emptyState: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .frame(height: 140)
            .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 6)
            .overlay(Text("Nenhuma atividade possui votos").foregroundColor(Color.ultramarineBlue))
            .padding(.horizontal)
    }
 
    private var cloud: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 6)
 
            ForEach(Array(viewModel.words.enumerated()), id: \.element.id) { idx, word in
                if idx < layout.items.count {
                    let item = layout.items[idx]
                    Text(word.text)
                        .font(.system(size: word.fontSize, weight: .semibold))
                        .foregroundColor(word.isWinner ? .nightBlue : .ultramarineBlue)
                        .multilineTextAlignment(.center)
                        .frame(width: item.frameWidth)
                        .position(item.position)
                }
            }
        }
        .frame(height: layout.totalHeight)
        .padding(.horizontal)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        availableWidth = geo.size.width
                        recalculate()
                    }
                    .onChange(of: geo.size.width) { w in
                        availableWidth = w
                        recalculate()
                    }
            }
        )
    }
 
    private func recalculate() {
        guard availableWidth > 0, !viewModel.words.isEmpty else { return }
        layout = CloudLayout.compute(words: viewModel.words, canvasWidth: availableWidth)
    }
}
 

 
struct CloudLayout {
 
    struct Item {
        let position:   CGPoint
        let frameWidth: CGFloat
    }
 
    let items:       [Item]
    let totalHeight: CGFloat
 
    static let empty = CloudLayout(items: [], totalHeight: 140)
  
    // Gap between the word bounding box and the rectangle border.
    private static let edgePadding: CGFloat = 20
    private static let wordGap: CGFloat = 8
    private static let maxWidthRatio: CGFloat = 0.65
    private static let minHeight: CGFloat = 140
 
    static func compute(words: [WordElement], canvasWidth: CGFloat) -> CloudLayout {
        let innerWidth   = canvasWidth - edgePadding * 2
        let maxWordWidth = innerWidth * maxWidthRatio
 
        let measurements = words.map { measure($0, maxWidth: maxWordWidth) }
        let sizes        = measurements.map { $0.size }
        let frameWidths  = measurements.map { $0.frameWidth }
 
        let stackedHeight = sizes.reduce(CGFloat(0)) { $0 + $1.height + wordGap }
        let startHeight   = max(minHeight, stackedHeight * 0.7)
        var canvasHeight  = startHeight
 
        for _ in 0..<30 {
            if let positions = spiral(
                sizes: sizes, frameWidths: frameWidths, words: words,
                canvasWidth: canvasWidth, canvasHeight: canvasHeight
            ) {
                return finalize(
                    positions: positions, sizes: sizes,
                    frameWidths: frameWidths, canvasWidth: canvasWidth
                )
            }
            canvasHeight += stackedHeight * 0.1
        }
 
        return rowLayout(sizes: sizes, frameWidths: frameWidths, canvasWidth: canvasWidth)
    }
 
    // MARK: - Measurement
 
    private struct Measurement {
        let size:       CGSize
        let frameWidth: CGFloat
    }
 
    /// Breaks text at word boundaries only.
    private static func measure(_ word: WordElement, maxWidth: CGFloat) -> Measurement {
        let font   = UIFont.systemFont(ofSize: word.fontSize, weight: .semibold)
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let spaceW = (" " as NSString).size(withAttributes: attrs).width
 
        let tokens = word.text.components(separatedBy: " ")
        var lines: [[String]] = []
        var currentLine: [String] = []
        var currentW: CGFloat = 0
 
        for token in tokens {
            let tokenW = (token as NSString).size(withAttributes: attrs).width
            let needed = currentLine.isEmpty ? tokenW : currentW + spaceW + tokenW
            if currentLine.isEmpty || needed <= maxWidth {
                currentLine.append(token)
                currentW = needed
            } else {
                lines.append(currentLine)
                currentLine = [token]
                currentW    = tokenW
            }
        }
        if !currentLine.isEmpty { lines.append(currentLine) }
 
        let widestW = lines.map { ($0.joined(separator: " ") as NSString).size(withAttributes: attrs).width }.max() ?? 0
        let totalH  = font.lineHeight * CGFloat(lines.count) + font.leading * CGFloat(Swift.max(lines.count - 1, 0))
 
        let size = CGSize(width: ceil(widestW) + 4, height: ceil(totalH) + 2)
        let frameWidth: CGFloat = lines.count == 1 ? size.width : maxWidth
 
        return Measurement(size: size, frameWidth: frameWidth)
    }
 
    // MARK: - Spiral
 
    private static func spiral(
        sizes:        [CGSize],
        frameWidths:  [CGFloat],
        words:        [WordElement],
        canvasWidth:  CGFloat,
        canvasHeight: CGFloat
    ) -> [CGPoint]? {
 
        var placed: [CGRect]  = []
        var result: [CGPoint] = []
 
        // The usable area for word centres.
        let safeEdge = edgePadding + 4
        let usable = CGRect(
            x: safeEdge,
            y: safeEdge,
            width:  canvasWidth  - safeEdge * 2,
            height: canvasHeight - safeEdge * 2
        )
 
        // Start from the upper-centre so words cluster toward the top.
        // After finalize() trims bottom whitespace the result looks compact.
        let startX = canvasWidth / 2
        let startY = edgePadding + usable.height * 0.35
 
        for (idx, word) in words.enumerated() {
            let size  = sizes[idx]
            let renderW = Swift.max(size.width, frameWidths[idx])
            let halfW = renderW   / 2 + wordGap / 2
            let halfH = size.height / 2 + wordGap / 2
 
            let diagonal    = sqrt(renderW * renderW + size.height * size.height)
            let radiusStep: CGFloat = 1.5
            let angleStep: CGFloat  = Swift.max(0.15, Swift.min(0.45, 8.0 / diagonal))
            let startAngle = CGFloat(abs(word.seed) % 628) / 100.0
 
            var found = false
            for step in 0..<8000 {
                let t      = CGFloat(step)
                let angle  = startAngle + t * angleStep
                let radius = t * radiusStep
 
                let cx = startX + cos(angle) * radius
                let cy = startY + sin(angle) * radius
 
                let rect = CGRect(
                    x: cx - halfW, y: cy - halfH,
                    width: halfW * 2, height: halfH * 2
                )
 
                guard usable.contains(rect) else { continue }
                guard placed.allSatisfy({ !$0.intersects(rect) }) else { continue }
 
                placed.append(rect)
                result.append(CGPoint(x: cx, y: cy))
                found = true
                break
            }
 
            if !found { return nil }
        }
 
        return result
    }
 
    // MARK: - Finalize
 
    /// Trims vertical whitespace and shifts everything so the top word
    /// sits exactly at edgePadding from the top of the rectangle.
    private static func finalize(
        positions:   [CGPoint],
        sizes:       [CGSize],
        frameWidths: [CGFloat],
        canvasWidth: CGFloat
    ) -> CloudLayout {
 
        let topEdge = positions.enumerated()
            .map { i, p in p.y - sizes[i].height / 2 }
            .min() ?? edgePadding
 
        let bottomEdge = positions.enumerated()
            .map { i, p in p.y + sizes[i].height / 2 }
            .max() ?? minHeight
 
        let dy      = edgePadding - topEdge
        let finalH  = max(minHeight, (bottomEdge - topEdge) + edgePadding * 2)
 
        let items = positions.enumerated().map { i, p -> Item in
            let renderW = Swift.max(sizes[i].width, frameWidths[i])
            let minX    = edgePadding + renderW / 2
            let maxX    = canvasWidth - edgePadding - renderW / 2
            let clampedX = Swift.min(Swift.max(p.x, minX), maxX)
            return Item(
                position:   CGPoint(x: clampedX, y: p.y + dy),
                frameWidth: frameWidths[i]
            )
        }
 
        return CloudLayout(items: items, totalHeight: finalH)
    }
 
    // MARK: - Row fallback
 
    private static func rowLayout(
        sizes:       [CGSize],
        frameWidths: [CGFloat],
        canvasWidth: CGFloat
    ) -> CloudLayout {
        var items: [Item] = []
        var x = edgePadding
        var y = edgePadding
        var rowH: CGFloat = 0
 
        for i in sizes.indices {
            let s = sizes[i]
            if x + s.width + edgePadding > canvasWidth, x > edgePadding {
                x    = edgePadding
                y   += rowH + wordGap
                rowH = 0
            }
            items.append(Item(
                position:   CGPoint(x: x + s.width / 2, y: y + s.height / 2),
                frameWidth: frameWidths[i]
            ))
            x    += s.width + wordGap
            rowH  = Swift.max(rowH, s.height)
        }
 
        return CloudLayout(items: items, totalHeight: Swift.max(minHeight, y + rowH + edgePadding))
    }
}
