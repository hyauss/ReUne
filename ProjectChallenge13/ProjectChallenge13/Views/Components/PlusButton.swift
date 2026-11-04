//
//  PlusButton.swift
//  ProjectChallenge13
//
//  Created by Francisco Losada on 22/05/26.
//

import SwiftUI

/// A circular plus button used in forms to indicate an add action.
struct PlusButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(.formPlusBack)
                .opacity(0.3)
            Image(systemName: "plus")
                .font(.system(size: 25, weight: .regular))
                .foregroundStyle(.formPlusText)
        }
    }
}

#Preview {
    PlusButton()
}
