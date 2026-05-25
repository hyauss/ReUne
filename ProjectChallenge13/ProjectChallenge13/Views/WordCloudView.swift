//
//  WordCloudView.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 22/05/26.
//

import SwiftUI

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: origin.x + size.width / 2, y: origin.y + size.height / 2)
    }
}

struct WordCloudView: View {
    @StateObject private var vm = WordCloudViewModel()
    @State private var canvasRect = CGRect()
    let group: EventGroup?

    init(group: EventGroup? = nil) {
        self.group = group
    }

    var body: some View {
        let positions = vm.positions.count == vm.words.count ? vm.positions : Array(repeating: .zero, count: vm.words.count)

        let innerPadding: CGFloat = 16

        Group {
            if vm.words.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "cloud.slash")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                    Text("Nenhuma atividade com votos ainda")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    Text("Peça para os participantes votarem.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(innerPadding)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.blue.opacity(0.08))
                )
            } else {
                ZStack {
                    ForEach(Array(vm.words.enumerated()), id: \.offset) { index, word in
                        Text(word.text)
                            .foregroundColor(word.color)
                            .font(.system(size: word.fontSize))
                            .lineLimit(1)
                            .fixedSize(horizontal: true, vertical: false)
                            .padding(3)
                            .background(WordSizeGetter(sizesBinding, index))
                            .position(x: canvasRect.width / 2 + positions[index].x, y: canvasRect.height / 2 + positions[index].y)
                    }
                }
                .padding(innerPadding) //
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.blue.opacity(0.08))
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        let total = proxy.size
                                        let inner = CGSize(width: max(0, total.width - innerPadding * 2), height: max(0, total.height - innerPadding * 2))
                                        DispatchQueue.main.async {
                                            canvasRect = CGRect(origin: .zero, size: inner)
                                            vm.updateCanvasSize(inner)
                                        }
                                    }
                                    .onChange(of: proxy.size) { _old, newSize in
                                        let inner = CGSize(width: max(0, newSize.width - innerPadding * 2), height: max(0, newSize.height - innerPadding * 2))
                                        DispatchQueue.main.async {
                                            canvasRect = CGRect(origin: .zero, size: inner)
                                            vm.updateCanvasSize(inner)
                                        }
                                    }
                            }
                        )
                )
            }
        }
        .padding(32)
        .onAppear {
            if let g = group {
                vm.setGroup(g)
            } else {
                vm.setActivities([])
            }
            vm.updateCanvasSize(canvasRect.size)
        }
        .onChange(of: canvasRect) { _old, newRect in
            vm.updateCanvasSize(newRect.size)
        }
        
    }

    private var sizesBinding: Binding<[CGSize]> {
        Binding(get: { vm.wordSizes }, set: { vm.wordSizes = $0 })
    }
}

struct WordSizeGetter: View {
    @Binding var sizes: [CGSize]
    let index: Int

    init(_ sizes: Binding<[CGSize]>, _ index: Int) {
        self._sizes = sizes
        self.index = index
    }

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .onAppear {
                    update(with: proxy.size)
                }
                .task(id: proxy.size) {
                    update(with: proxy.size)
                }
        }
    }

    private func update(with size: CGSize) {
        DispatchQueue.main.async {
            guard index >= 0 else { return }
            if index < sizes.count {
                if sizes[index] != size {
                    sizes[index] = size
                }
            } else if index == sizes.count {
                sizes.append(size)
            }
        }
    }
}

//#Preview {
//    let sampleActivities = [
//        ActivitiesModel(name: "Cinema", votos: 8),
//        ActivitiesModel(name: "Parque", votos: 5),
//        ActivitiesModel(name: "Brunch", votos: 2),
//        ActivitiesModel(name: "Museu", votos: 0)
//    ]
//    let sampleGroup = EventGroup(recordId: nil, users: Set(["previewUser"]), categories: [], activities: sampleActivities, dates: [])
//    WordCloudView(group: sampleGroup)
//}
