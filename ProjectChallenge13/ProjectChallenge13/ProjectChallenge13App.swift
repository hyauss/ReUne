//
//  ProjectChallenge13App.swift
//  ProjectChallenge13
//
//  Created by Vinicius Marques on 14/05/26.
//

import SwiftUI
import Aptabase

@main
struct ProjectChallenge13App: App {
    init() {
            Aptabase.shared.initialize(appKey: "A-US-8107330164") // 👈 this is where you enter your App Key
        }
    var body: some Scene {
        WindowGroup {
//            ContentView()
            AptabaseTesteView()
        }
    }
}
