//
//  AddGroupButtonComponent.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import Aptabase

struct AddGroupButtonComponent: View {
    var body: some View {
        Button{
            Aptabase.shared.trackEvent("new_group")
            //NewGroupSheetView()
        }label:{
            Image(systemName: "plus").foregroundStyle(.black)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .glassEffect()
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddGroupButtonComponent()
}
