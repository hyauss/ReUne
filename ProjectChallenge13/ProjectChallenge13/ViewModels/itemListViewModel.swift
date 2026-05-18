//
//  itemListViewModel.swift
//  PocCloudKit
//
//  Created by Vinicius Marques on 13/05/26.
//

import Foundation
import CloudKit
import Combine

enum RecordType: String{
    case itemListing = "ItemListing"
}


class ItemListingViewModel: ObservableObject {

    private var database: CKDatabase
    private var contaniner: CKContainer
    
    init() {
        self.contaniner = CKContainer.default()
        self.database = self.contaniner.publicCloudDatabase
        
    }
    
    func saveItem (title: String, price: Decimal){
        let record = CKRecord(recordType: RecordType.itemListing.rawValue)
        let itemListing = ItemListing(title: title, price: price)
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
}
