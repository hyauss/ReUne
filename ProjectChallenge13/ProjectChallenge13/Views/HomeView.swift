//
//  HomeView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI

struct HomeView: View {
    @State private var grupos: [EventGroup] = [
        EventGroup(users: [], categories: [], activities: [], dates: []),
        EventGroup(users: [], categories: [], activities: [], dates: []),
        EventGroup(users: [], categories: [], activities: [], dates: []),
        EventGroup(users: [], categories: [], activities: [], dates: []),
        EventGroup(users: [], categories: [], activities: [], dates: []),
        EventGroup(users: [], categories: [], activities: [], dates: [])
    ]
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    ForEach(Array(grupos.enumerated()), id: \.element.id) { index, grupo in
                        GroupCardComponent(groupNumber: index + 1)
                    }
                }
            }
            .navigationTitle("Seus Grupos")
            .toolbar{
                ToolbarItem(placement:.confirmationAction){
                    AddGroupButtonComponent()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
