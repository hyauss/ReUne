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
    @State private var title: String = ""
    @State private var price: String = ""
    @State var ckViewModel = LoginViewModel.shared
    @State private var users: Set<String> = []
    @StateObject private var vmNotification = PushNotificationViewModel()
    
    var body: some View {
    
        VStack{
            TextField("Enter title", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("Enter price", text: $price)
                .textFieldStyle(.roundedBorder)
        }
        
        Spacer()
        
        Button("Save"){
            guard let price = try? Decimal(price, format: .number) else {return}
            users.insert(ckViewModel.preference?.userID ?? "")
            
            vm.saveItem(title: title, price: price, users: users)
            self.title = ""
            self.price = ""
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
                    Text(item.title)
                    Spacer()
                    Text("$" + String(describing: item.price))
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
