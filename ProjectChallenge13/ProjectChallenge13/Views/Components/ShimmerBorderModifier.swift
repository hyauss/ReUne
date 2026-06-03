//
//  ShimmerBorder.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 28/05/26.
//

import SwiftUI

struct ShimmerBorderModifier: ViewModifier {
    var animate: Bool
    @State private var isAnimating: Bool = false
    @State private var startDate: Date = .now
    
    private let duration: Double = 2
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isAnimating {
                        TimelineView(.animation) { timeline in
                            let elapsed = timeline.date.timeIntervalSince(startDate)
                            let phase   = min(CGFloat(elapsed / duration), 1.0)
                            let fadeOut: CGFloat = phase > 0.85 ? 1 - (phase - 0.85) / 0.15 : 1.0
                            
                            GeometryReader { geo in
                                Canvas { ctx, size in
                                    let rect = CGRect(origin: .zero, size: size)
                                    let pts  = perimeterPoints(rect: rect, steps: 500)
                                    let N    = pts.count
                                    let trail  = Int(CGFloat(N) * 0.09)
                                    let offset = Int(phase * CGFloat(N))
                                    
                                    // top-right ≈ 25% | bottom-left ≈ 75%
                                    drawShimmer(ctx, pts, center: (N/4  + offset) % N, trail: trail, alpha: fadeOut)
                                    drawShimmer(ctx, pts, center: (3*N/4 + offset) % N, trail: trail, alpha: fadeOut)
                                }
                            }
                        }
                    }
                }
                    .allowsHitTesting(false)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            )
            .onChange(of: animate) { previous, current in
                guard current else { return }
                startDate   = .now
                isAnimating = true

                DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.05) {
                    isAnimating = false
                }
            }
    }
    
    // MARK: - Draw the shimmer
    
    private func drawShimmer(
        _ ctx: GraphicsContext,
        _ pts: [CGPoint],
        center: Int,
        trail: Int,
        alpha: CGFloat
    ) {
        let N = pts.count
        for i in stride(from: -trail, through: trail, by: 1) {
            let curr = ((center + i)     % N + N) % N
            let prev = ((center + i - 1) % N + N) % N
            
            var seg = Path()
            seg.move(to: pts[prev])
            seg.addLine(to: pts[curr])
            
            let t = CGFloat(i + trail) / CGFloat(trail * 2)
            let a = Double(sin(t * .pi) * alpha)
            
            ctx.stroke(seg, with: .color(.ultramarineBlue.opacity(a)),
                       style: StrokeStyle(lineWidth: 3.5, lineCap: .round))
        }
    }
    
    // MARK: - Create the points along the perimeter of a rounded rectangle
    
    private func perimeterPoints(rect: CGRect, steps: Int) -> [CGPoint] {
        let r  = CGFloat(20)
        let W  = rect.width, H = rect.height
        let sH = W - 2*r, sV = H - 2*r
        let arcLen    = CGFloat.pi / 2 * r
        let perimeter = 2*(sH + sV) + 4*arcLen
        func n(_ len: CGFloat) -> Int { max(2, Int((len/perimeter) * CGFloat(steps))) }
        
        var pts = [CGPoint]()
        
        let stH = n(sH), stV = n(sV), stA = n(arcLen)
        
        // 1. topo esq→dir
        for i in 0...stH { pts.append(.init(x: r + sH*CGFloat(i)/CGFloat(stH), y: 0)) }
        // 2. arco top-right
        for i in 0...stA {
            let a = -.pi/2 + (.pi/2)*CGFloat(i)/CGFloat(stA)
            pts.append(.init(x: W-r + r*cos(a), y: r + r*sin(a)))
        }
        // 3. lado direito ↓
        for i in 0...stV { pts.append(.init(x: W, y: r + sV*CGFloat(i)/CGFloat(stV))) }
        // 4. arco bottom-right
        for i in 0...stA {
            let a = CGFloat(0) + (.pi/2)*CGFloat(i)/CGFloat(stA)
            pts.append(.init(x: W-r + r*cos(a), y: H-r + r*sin(a)))
        }
        // 5. fundo dir→esq
        for i in 0...stH { pts.append(.init(x: W-r - sH*CGFloat(i)/CGFloat(stH), y: H)) }
        // 6. arco bottom-left
        for i in 0...stA {
            let a = .pi/2 + (.pi/2)*CGFloat(i)/CGFloat(stA)
            pts.append(.init(x: r + r*cos(a), y: H-r + r*sin(a)))
        }
        // 7. lado esquerdo ↑
        for i in 0...stV { pts.append(.init(x: 0, y: H-r - sV*CGFloat(i)/CGFloat(stV))) }
        // 8. arco top-left
        for i in 0...stA {
            let a = .pi + (.pi/2)*CGFloat(i)/CGFloat(stA)
            pts.append(.init(x: r + r*cos(a), y: r + r*sin(a)))
        }
        
        return pts
    }
}

extension View {
    func shimmerBorder(animate: Bool) -> some View {
        modifier(ShimmerBorderModifier(animate: animate))
    }
}
