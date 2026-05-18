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
        Button("Save"){
            guard let price = try? Decimal(price, format: .number) else {return}
            vm.saveItem(title: title, price: price)
            self.title = ""
            self.price = ""
        }
        
        Button("Permissions") {
            vmNotification.requestNotificationPermission()
        }
        
        Button("subscription") {
            vmNotification.subscribeToNotification()
        }
        
        Button("unsubscription") {
            vmNotification.unsubscribeToNotification()
        }
    }
}

//#Preview {
//    ContentView(vm: ItemListingViewModel())
//}
