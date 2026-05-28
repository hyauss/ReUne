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
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .frame(width: 140, alignment: .center)
            Spacer()
            
            ZStack{
//                if opacity1 < opacity2{
//                    Capsule()
//                        .foregroundStyle(Color(hue: 0.669, saturation: opacity1 * 0.93, brightness: 1 - (0.40 * opacity1)))
//                        .frame(maxWidth: 218, maxHeight: 50)
//                    HStack{
//                        Spacer()
//                        Capsule()
//                            .foregroundStyle(Color(hue: 0.669, saturation: opacity2 * 0.93, brightness: 1 - (0.40 * opacity2)))
//                            .frame(maxWidth: 108, maxHeight: 50)
//                        
//                    }
//                }
//                else{
                    
                    Capsule()
                        .foregroundStyle(Color(hue: 0.669, saturation: opacity2 * 0.93, brightness: 1 - (0.40 * opacity2)))
                        .frame(maxWidth: 218, maxHeight: 50)
                    HStack{
                        Capsule()
                            .foregroundStyle(Color(hue: 0.669, saturation: opacity1 * 0.93, brightness: 1 - (0.40 * opacity1)))
                            .frame(maxWidth: 108, maxHeight: 50)
                        Spacer()
                    }
//                }
            }
        }
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 50, topTrailing: 50))
                .foregroundStyle(Color(hue: 0.669, saturation: 0.093, brightness: 0.97))
                .frame(maxWidth: 360, maxHeight: 50)
        )
    }
}

#Preview {
    TimeComponent(time: Date(), opacity1: 0.5, opacity2: 0.7)
}
