//
//  DayCell.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 28/05/26.
//

import SwiftUI

struct DayCellView: View {
    let day: Date
    let isMostFrequent: Bool
    let opacity: Double
    
    var body: some View {
        Text(day.formatted(.dateTime.day()))
            .font(isMostFrequent ? .title2 : .title3)
            .fontWeight(isMostFrequent ? .medium : .regular)
            .frame(maxWidth: .infinity, minHeight: 40)
            .foregroundStyle(isMostFrequent ? .white : .black)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(
                        hue: 0.669,
                        saturation: opacity * 0.93,
                        brightness: 1 - (0.40 * opacity)
                    ))
            )
    }
}

//
//#Preview {
//    DayCell()
//}
