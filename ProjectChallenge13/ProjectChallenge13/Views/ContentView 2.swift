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
    @StateObject private var vmNotification = PushNotificationViewModel.shared
    
    var body: some View {
        Spacer()
        
        Button("Save"){
            users.insert(ckViewModel.preference!.userID)
            vm.saveItem(categories: [CategoryModel(name: "testes1")], activities: [ActivitiesModel(name: "1131231", votos: 1),ActivitiesModel(name: "wow", votos: 5),ActivitiesModel(name: "ajhsfdga", votos: 10),ActivitiesModel(name: "birobiro", votos: 2),ActivitiesModel(name: "3452", votos: 8),ActivitiesModel(name: "1234", votos: 4),ActivitiesModel(name: "bdyb", votos: 8),ActivitiesModel(name: "uynuyu", votos: 2),ActivitiesModel(name: "dbbd", votos: 4),ActivitiesModel(name: "sg4fg534", votos: 13),ActivitiesModel(name: "nfgnyn", votos: 14),ActivitiesModel(name: "jrtg843", votos: 11)], dates: [Calendar.current.date(from: DateComponents(year: 2026, month: 5, day: 22, hour: 10))!], users: users, owner: ckViewModel.preference!.userID)
        }
        
        
        Spacer()
        
        Button("Permissions") {
            vmNotification.requestNotificationPermission()
        }
        
        Spacer()
        
//        Button("subscription") {
//            vmNotification.subscribeToNotification()
//        }
        
        Spacer()
        
//        Button("unsubscription") {
//            vmNotification.unsubscribeToNotification()
//        }
        
        Spacer()
        
        List{
            ForEach(vm.items, id: \.recordId){ item in
                HStack{
                    Spacer()
                    Text(item.owner)
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
//        .onAppear {
//            vm.fetchGroupsWithUserId()
//        }
    }
       
}

//#Preview {
//    ContentView(vm: ItemListingViewModel())
//}
