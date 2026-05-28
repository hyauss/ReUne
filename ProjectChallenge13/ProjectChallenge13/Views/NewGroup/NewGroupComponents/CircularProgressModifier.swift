//
//  CircularProgressModifier.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 28/05/26.
//

import SwiftUI

struct CircularProgressModifier: ViewModifier {
    let onComplete: () -> Void
    private let duration: Double = 0.9

    @State private var isAnimating = false
    @State private var startDate: Date = .now
    @State private var done = false

    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(
                ZStack {
                    Circle()
                        .fill(Color.ultramarineBlue)

                    if isAnimating {
                        TimelineView(.animation) { timeline in
                            let elapsed = timeline.date.timeIntervalSince(startDate)
                            let progress = min(elapsed / duration, 1.0)

                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Color.nightBlue,
                                        style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .onChange(of: progress >= 1.0) { completed in
                                    guard completed else { return }
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        done = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        onComplete()
                                    }
                                }
                        }
                    }
                }
            )
            .onTapGesture {
                guard !isAnimating && !done else { return }
                startDate   = .now
                isAnimating = true
            }
    }
}

extension View {
    func circularProgressButton(onComplete: @escaping () -> Void) -> some View {
        modifier(CircularProgressModifier(onComplete: onComplete))
    }
}
