//
//  BenefitRow.swift
//  ProjectChallenge13
//
//  Created by Rafael Neves de Oliveira on 12/06/26.
//

import SwiftUI

struct BenefitRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.yellow)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
    }
}
