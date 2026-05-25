//
//  GroupCardComponent.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI

struct GroupCardComponent: View {
    var groupNumber: Int
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.gray)
            .frame(width: 344, height: 104)
            .overlay(
                Text("Grupo \(groupNumber)")
                    .padding(.leading, 22)
                    .frame(width:344,height: 54,alignment: .leading)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20)),
                alignment: .top
            )
        
    }
}

#Preview {
    GroupCardComponent(groupNumber: 1)
}
