//
//  ContentView.swift
//  Poc_PushNotificationCloudkit
//
//  Created by anshu Li on 13/05/26.
//

import SwiftUI
import CloudKit

struct ContentView2: View {
    @StateObject private var vm =  GroupViewModel.shared
    @State var ckViewModel = LoginViewModel.shared
    @State private var users: Set<String> = []
    @StateObject private var vmNotification = PushNotificationViewModel()
    
    var body: some View {
        Spacer()
        
        Button("Save"){
            users.insert(ckViewModel.preference!.userID)
            vm.saveItem(categories: [CategoryModel(name: "testes1", votos: 0)], activities: [ActivitiesModel(name: "lerolero", votos: 0)], dates: [Date.now], users: users)
        }
        
        
        Spacer()
        
        Button("Permissions") {
            vmNotification.requestNotificationPermission()
        }
        
        Spacer()
        
        Button("subscription") {
            vmNotification.subscribeToNotification()
        }
        
        Spacer()
        
        Button("unsubscription") {
            vmNotification.unsubscribeToNotification()
        }
        
        Spacer()
        
        List{
            ForEach(vm.items, id: \.recordId){ item in
                HStack{
                    Spacer()
                    Text(item.dates.description)
                    Text(item.categories.description)
                    Text(item.actitivies.description)
                    Text(item.users.description)
                    if let url = URL(string: "challenge13://\(item.recordId?.recordName ?? "NoGroup")") {
                        ShareLink(item: url) {
                            Label("Compartilhar", systemImage: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        
        .navigationTitle("Items")
        .padding()
        .onAppear {
            vm.fetchGroupsWithUserId()
        }
    }
       
}

//#Preview {
//    ContentView(vm: ItemListingViewModel())
//}
