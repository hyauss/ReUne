//
//  PlusButton.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

struct PlusButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 32, height: 32)
                .foregroundStyle(.formPlusBack)
                .opacity(0.3)
            Image(systemName: "plus")
                .font(.body)
                .foregroundStyle(.formPlusText)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    PlusButton()
}
