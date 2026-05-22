//
//  HomeView.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import Aptabase

struct HomeView: View {
    @State private var groups: [SocialGroup] = [
        SocialGroup(groupNumber: 1),
        SocialGroup(groupNumber: 2),
        SocialGroup(groupNumber: 3),
        SocialGroup(groupNumber: 4),
        SocialGroup(groupNumber: 5),
        SocialGroup(groupNumber: 6),
        SocialGroup(groupNumber: 7),
        SocialGroup(groupNumber: 8),
    ]
    
    var body: some View {
        NavigationStack {
            VStack{
                ScrollView {
                    ForEach(groups) { number in
                        GroupCardComponent(groupNumber: number.groupNumber)
                    }
                }
            }
            .navigationTitle("Seus Grupos")
            .toolbar{
                ToolbarItem(placement:.confirmationAction){
                    Button{
                        Aptabase.shared.trackEvent("new_group")
                        //NewGroupSheetView()
                    }label:{
                        Image(systemName: "plus").foregroundStyle(.black)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .glassEffect()
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
