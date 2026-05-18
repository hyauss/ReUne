//
//  itemListing.swift
//  PocCloudKit
//
//  Created by Vinicius Marques on 13/05/26.
//

import Foundation
import CloudKit

struct ItemListing{
    
    var recordId: CKRecord.ID?
    let title: String
    let price: Decimal
    
    init(recordId: CKRecord.ID? = nil, title: String, price: Decimal) {
        self.recordId = recordId
        self.title = title
        self.price = price
    }
    
    func toDictionary() -> [String: Any]{
        return ["title": title, "price": price]
    }
}
