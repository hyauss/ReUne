//
//  itemListing.swift
//  PocCloudKit
//
//  Created by Vinicius Marques on 13/05/26.
//

import Foundation
import CloudKit

struct EventGroup{
    
    var recordId: CKRecord.ID?
    var title: String
    var price: Decimal
    var users: Set<String>
    
    init(recordId: CKRecord.ID? = nil, title: String, price: Decimal, users: Set<String>) {
        self.recordId = recordId
        self.title = title
        self.price = price
        self.users = users
    }
    
    func toDictionary() -> [String: Any]{
        return ["title": title, "price": price, "users": Array(users)]
    }
    
    static func fromRecord(_ record: CKRecord) -> EventGroup? {
        
        guard let title = record.value(forKey: "title") as? String, let price = record.value(forKey: "price") as? Double, let users = record.value(forKey: "users") as? [String]
        else{
            return nil
        }
        
        return EventGroup(recordId: record.recordID, title: title, price: Decimal(price), users: Set(users))
    }
}
