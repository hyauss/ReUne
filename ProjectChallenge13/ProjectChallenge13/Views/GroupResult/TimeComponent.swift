//
//  TimeComponent.swift
//  ProjectChallenge13
//
//  Created by anshu Li on 20/05/26.
//

import SwiftUI

struct TimeComponent: View {
    var time: Date
    var opacity1: Double
    var opacity2: Double
    
    
    var body: some View {
        HStack{
            Text("\(time.toString(format: "HH")):00")
                .padding()
//                .font(.system(size: 30, weight: .semibold))
                .font(.largeTitle)
                .foregroundStyle(.gray)
                .frame(width: 140, alignment: .center)
            Spacer()
            ZStack{
                Capsule()
                    .foregroundStyle(Color(hue: 0.9, saturation: opacity2, brightness: 1))
                    .frame(maxWidth: 218, maxHeight: 50)
                HStack{
                    Capsule()
                        .foregroundStyle(Color(hue: 0.9, saturation: opacity1, brightness: 1))
                        .frame(maxWidth: 108, maxHeight: 50)
                    Spacer()
                }
            }
        }
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 50, topTrailing: 50))
                .foregroundStyle(Color(hue: 0.9, saturation: 0.1, brightness: 1))
                .frame(maxWidth: 360, maxHeight: 50)
        )
    }
}

#Preview {
    TimeComponent(time: Date(), opacity1: 0.5, opacity2: 0.7)
}
