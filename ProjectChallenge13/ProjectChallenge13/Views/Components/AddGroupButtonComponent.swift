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
    
    @StateObject private var store = StoreKitManager.shared
    @StateObject private var vm = GroupViewModel.shared
    @State private var showPaywall: Bool = false

        private let freeGroupLimit = 5
    
    var body: some View {
        Button {
            Aptabase.shared.trackEvent("new_group")
            if store.isPremium || vm.records.count < freeGroupLimit {
                newGroupSheet.toggle()
            } else {
                showPaywall.toggle()
            }
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.black)
//                .font(.system(size: 17, weight: .medium))
//                .foregroundColor(.white)
//                .glassEffect()
//                .clipShape(Circle())
        }
        
        .sheet(isPresented: $newGroupSheet) {
            NewGroupSheetView(formRecord: $formRecord, newGroupCreated: $newGroupCreated)
        }
        .sheet(isPresented: $showPaywall) {
                    PremiumPaywallView()
                }
    }
}
