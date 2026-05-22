//
//  itemListViewModel.swift
//  PocCloudKit
//
//  Created by Vinicius Marques on 13/05/26.
//

import Foundation
import CloudKit
import Combine
import SwiftUI

enum RecordType: String{
    case itemListing = "ItemListing"
}


class GroupViewModel: ObservableObject {
    
    var ckViewModel = LoginViewModel.shared
    static let shared = GroupViewModel()
    private var database: CKDatabase
    private var contaniner: CKContainer
    
    @Published var items: [ItemViewModel] = []
    
    private init() {
        self.contaniner = CKContainer.default()
        self.database = self.contaniner.publicCloudDatabase
        
    }
    
    func save(groupRecord: CKRecord) async{
        do{
            try await self.database.save(groupRecord)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func saveItem (categories: [CategoryModel], activities: [ActivitiesModel], dates: [Date],users: Set<String>){
        let record = CKRecord(recordType: RecordType.itemListing.rawValue)
        let itemListing = EventGroup(recordId: record.recordID, users: users, categories: categories, activities: activities, dates: dates)
        record.setValuesForKeys(itemListing.toDictionary())
        
        self.database.save(record){ newRecord, error in
            if let error = error{
                print(error)
            }else{
                if let _ = newRecord{
                    print("SAVED")
                }
            }
        }
    }
    
    func fetchGroupsWithUserId(){
        
        var items: [EventGroup] = []
        
        let query = CKQuery(recordType: RecordType.itemListing.rawValue, predicate: NSPredicate(format: "ANY users == %@", ckViewModel.preference?.userID ?? ""))
        
        database.fetch(withQuery: query){ result in
            switch result{
            case .success(let result):
                result.matchResults.compactMap{$0.1}
                    .forEach{
                        switch $0 {
                        case .success(let record):
                            if let itemListing  = EventGroup.fromRecord(record){
                                items.append(itemListing)
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
                
                DispatchQueue.main.async {
                    self.items = items.map(ItemViewModel.init)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchGroupsWithId(groupID: String) async throws -> CKRecord {
            
        let recordID = CKRecord.ID(recordName: groupID)

        return try await database.record(for: recordID)
    }
}

struct ItemViewModel{
    let itemListing: EventGroup
    
    var recordId: CKRecord.ID?{
        itemListing.recordId
    }
    
    var categories: [CategoryModel] {
        itemListing.categories
    }
    
    var actitivies: [ActivitiesModel]{
        itemListing.activities
    }
    
    var users: Set<String>{
        itemListing.users
    }
    
    var dates: [Date]{
        itemListing.dates
    }
}

