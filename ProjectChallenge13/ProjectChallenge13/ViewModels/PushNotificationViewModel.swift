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


class PushNotificationViewModel: ObservableObject{
    
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
        
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "ItemListing", predicate: predicate, subscriptionID: "listing_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "New Item"
        notification.alertBody = "Open the app to check"
        notification.soundName = "default"
        
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
