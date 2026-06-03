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
    
    func subscribeToNotification(groupID: String) {
        let recordID = CKRecord.ID(recordName: groupID)
        let predicate = NSPredicate(format: "recordID == %@", recordID)
        let subscriptionID = "group_update_\(groupID)"
        
        let subscription = CKQuerySubscription(recordType: "ItemListing", predicate: predicate, subscriptionID: subscriptionID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "Atualização no grupo"
        notification.alertBody = "Houver uma atualização no grupo \(groupID)"
        notification.soundName = "default"
        notification.shouldSendContentAvailable = true
        
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                if let ckError = returnedError as? CKError, ckError.code == .serverRejectedRequest {
                    print("Subscription already exists: \(groupID)")
                } else {
                    print("Noti funcao caiu no erro: \(groupID) " )
                    print(error)
                }
            }
            else{
                print("Sucess subscribe to group: \(groupID)")
            }
        }
        
        print("Noti funcao: \(groupID) " )
    }
    
    func unsubscribeToNotification(groupID: String) {
        let subscriptionID = "group_update_\(groupID)"
        
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedID, returnedError in
            if let error = returnedError {
                print (error)
            }
            else{
                print("Unsubscribed: \(groupID)")
            }
        }
    }
    
    
}
