//
//  AddGroupButtonComponent.swift
//  ProjectChallenge13
//
//  Created by Carolina Sun on 22/05/26.
//

import SwiftUI
import Aptabase
import CloudKit

struct AddGroupButtonComponent: View {
    @State var newGroupSheet: Bool = false
    @Binding var newGroupCreated: Bool
    @Binding var formRecord: CKRecord
    
    var body: some View {
        Button{
            Aptabase.shared.trackEvent("new_group")
            newGroupSheet.toggle()
        }label:{
            Image(systemName: "plus").foregroundStyle(.black)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .glassEffect()
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $newGroupSheet) {
            NewGroupSheetView(formRecord: $formRecord, newGroupCreated: $newGroupCreated)
        }
    }
}
