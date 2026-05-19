//
//  ContentView.swift
//  Poc_PushNotificationCloudkit
//
//  Created by anshu Li on 13/05/26.
//

import SwiftUI

struct ContentView2: View {
    @StateObject private var vm: ItemListingViewModel
    @State private var title: String = ""
    @State private var price: String = ""
    @StateObject private var vmNotification = PushNotificationViewModel()
    
    init(vm: ItemListingViewModel) {
            _vm = StateObject(wrappedValue: vm)
    }
    
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
            vm.saveItem(title: title, price: price)
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
                }
            }
        }
        
        .navigationTitle("Items")
        .padding()
        .onAppear {
            vm.fetchItem()
        }
    }
       
}

//#Preview {
//    ContentView(vm: ItemListingViewModel())
//}
