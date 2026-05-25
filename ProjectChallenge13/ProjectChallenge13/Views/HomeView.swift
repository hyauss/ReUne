//
//  HomeView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm =  GroupViewModel.shared
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    ForEach(Array(vm.items.enumerated()), id: \.element.recordId) { index, item in
                        NavigationLink {
                            GrupResultView(group:item)
                        } label: {
                            GroupCardComponent(groupNumber: index + 1)
                        }
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
//    ContentView()
}
