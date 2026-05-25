//
//  Aptabase.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 19/05/26.
//

import Foundation
import SwiftUI
import Aptabase

struct AptabaseTesteView: View {
    //Aptabase.shared.trackEvent("app_started") // An event with no properties
    //Aptabase.shared.trackEvent("screen_view", with: ["name": "Settings"]) // An event with a custom property
    @State private var day = 19.0
    var body: some View {
        Button("Confirmar presença") {
            Aptabase.shared.trackEvent("confirmar_presenca")
        }
        
        Text("Qual dia posso ir?: \(Int(day))")
        Slider(value: $day,in: 0...31,onEditingChanged: { editing in
                if !editing {
                    Aptabase.shared.trackEvent("day",with: ["value": "8"])
                }
            }
        )
        .padding()

    }
}
