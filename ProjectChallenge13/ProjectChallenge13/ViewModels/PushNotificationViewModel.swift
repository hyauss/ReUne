//
//  PushNotification.swift
//  Poc_PushNotificationCloudkit
//
//  Created by anshu Li on 14/05/26.
//

import Foundation
import UIKit
import CloudKit
import Combine
import SwiftUI


class PushNotificationViewModel: ObservableObject{
    @StateObject private var vm =  GroupViewModel.shared
    
    func requestNotificationPermission() {
        
        let options: UNAuthorizationOptions = [.alert,.badge,.sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            
            if granted {
                print("Permissão concedida")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Permissão negada")
            }
            if let error = error {
                print("Erro: \(error.localizedDescription)")
            }
        }
    }
    
    func subscribeToNotification() {
        let groupIDs = vm.records
        
        for groupID in groupIDs {
            
            let predicate = NSPredicate(format: "groupID == %@", groupID)
            let subscription = CKQuerySubscription(recordType: "ItemListing", predicate: predicate, subscriptionID: "subID-\(groupID)", options: .firesOnRecordCreation)
            
            let notification = CKSubscription.NotificationInfo()
            notification.title = "Atualização no grupo"
            notification.alertBody = "Houver uma atualização no grupo \(groupID)"
            notification.soundName = "default"
            
            notification.threadIdentifier = groupID
            
            subscription.notificationInfo = notification
            
            CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
                if let error = returnedError {
                    print(error)
                }
                else{
                    print("Sucess subscribe")
                }
            }
        }
        
//        let predicate = NSPredicate(value: true)
//        let subscription = CKQuerySubscription(recordType: "ItemListing", predicate: predicate, subscriptionID: "listing_added_to_database", options: .firesOnRecordCreation)
        
//        let notification = CKSubscription.NotificationInfo()
//        notification.title = "New Item"
//        notification.alertBody = "Open the app to check"
//        notification.soundName = "default"
        
    }
    
    func unsubscribeToNotification() {
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "listing_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print (error)
            }
            else{
                print("unsubscribe sucess")
            }
        }
    }
    
    
}
