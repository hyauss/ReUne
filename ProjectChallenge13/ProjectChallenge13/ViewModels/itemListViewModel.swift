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
    
    @Published var items: [ItemViewModel] = []
    
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
    
    func fetchItem(){
        
        var items: [ItemListing] = []
        
        let query = CKQuery(recordType: RecordType.itemListing.rawValue, predicate: NSPredicate(value: true))
        
        database.fetch(withQuery: query){ result in
            switch result{
            case .success(let result):
                result.matchResults.compactMap{$0.1}
                    .forEach{
                        switch $0 {
                        case .success(let record):
                            if let itemListing  = ItemListing.fromRecord(record){
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
}


    
    func editItem(){
        
    }
    
    func deteleItem(){
        
    }
    
    struct ItemViewModel{
        let itemListing: ItemListing
        
        var recordId: CKRecord.ID?{
            itemListing.recordId
        }
        
        var title: String {
            itemListing.title
        }
        
        var price: Decimal{
            itemListing.price
        }
    }
    
