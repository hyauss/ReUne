//
//  Item.swift
//  PoCLoginCloudKit
//
//  Created by Francisco Losada on 13/05/26.
//

import Foundation
import CloudKit
import SwiftUI
import Observation

@Observable
@MainActor
class LoginViewModel {
    
    static let shared = LoginViewModel()
    
    private var userID: String = ""
    var name: String? = ""
    
    var isLogged: Bool = false
    
    var container : CKContainer
    
    var preference: Preference? = nil
    
    func loginButtonPressed() {
        guard name != nil, !name!.isEmpty else { return }
        
        createPreference(name: name!)
    }
    
    private init(container: CKContainer = .default()) {
        self.container = container
        
        getPreferenceRecordID { recordID, error in
            if let returnedPreferenceID = recordID?.recordName {
                self.isLogged(idUser: returnedPreferenceID)
            }
        }
    }
    
    func createPreference(name: String) {
        let newPreference = CKRecord(recordType: "preferences")
        
        getPreferenceRecordID { recordID, error in
            if let userID = recordID?.recordName {
                newPreference["name"] = name
                newPreference["ID"] = userID
                
                self.sendPreferenceToDB(record: newPreference)
            }
            else {
                
                print("Fetched iCloudID returned nil")
            }
        }
    }
    
    func removePreference(preference: Preference) async throws {
        let record = preference.record
        do {
            try await container.privateCloudDatabase.deleteRecord(withID: record.recordID)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func getPreferenceRecordID(complete: @escaping (_ instance: CKRecord.ID?, _ error: NSError?) -> ()) {
        let container = CKContainer.default()
        container.fetchUserRecordID() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(nil, error as NSError?)
            } else {
                complete(recordID, nil)
            }
        }
    }
    
    func isLogged(idUser: String) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "preferences", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedMatchingPreference: [Preference] = []
        
        queryOperation.recordMatchedBlock = { [weak self] returnedRecordID, returnedResult in
            switch returnedResult {
            case .success(let record):
                guard let id = record["ID"] as? String else { return }
                guard let name = record["name"] as? String else { return }
                
                if id == idUser {
                    returnedMatchingPreference.append(Preference(name: name, userID: idUser, record: record))
                    DispatchQueue.main.async {
                        self?.preference = Preference(name: name, userID: idUser, record: record)
                    }
                }
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }
        
        queryOperation.queryResultBlock = { [weak self] returnedResult in
            print("Returned result: \(returnedResult)")
            DispatchQueue.main.async {
                if !returnedMatchingPreference.isEmpty {
                    self?.isLogged = true
                    print("There's a user with that ID")
                }
            }
        }
        
        addOperationToPrivateDB(operation: queryOperation)
    }
    
    func fetchAndDeletePreference() {
        getPreferenceRecordID { recordID, error in
            if let returnedPreferenceID = recordID?.recordName {
                self.isLogged(idUser: returnedPreferenceID)
                
                Task {
                    if let _preference = self.preference {
                        try await self.removePreference(preference: _preference)
                        
                        self.isLogged = false
                    }
                }
            }
        }
    }
    
    func sendPreferenceToDB(record: CKRecord) {
        container.privateCloudDatabase.save(record) { [weak self] returnedRecord, returnedError in
            if let error = returnedError {
                print(error.localizedDescription)
                return
            }
            
            guard let returnedRecord = returnedRecord,
                  let name = returnedRecord["name"] as? String,
                  let userID = returnedRecord["ID"] as? String
            else {
                return
            }
            
            let pref = Preference(
                name: name,
                userID: userID,
                record: returnedRecord
            )
            
            DispatchQueue.main.async {
                self?.preference = pref
                self?.isLogged = true
                self?.name = ""
            }
        }
    }
    
    func sendEntryToDB(record: CKRecord) {
        container.privateCloudDatabase.save(record) { returnedRecord, returnedError in
            print(returnedError ?? "")
            print(returnedRecord ?? "")
        }
    }
    
    func addOperationToPrivateDB(operation: CKDatabaseOperation) {
        container.privateCloudDatabase.add(operation)
    }
    
    
}


