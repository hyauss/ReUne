//
//  ContentView.swift
//  ProjectChallenge13
//
//  Created by Vinicius Marques on 14/05/26.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                EntryView()
                NavigationLink {
                    ContentView2(vm: ItemListingViewModel())
                } label: {
                    Text("PushNotificationIcloud")
                }
            }
        }
    }
}
