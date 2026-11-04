////
////  ProjectChallenge13Tests.swift
////  ProjectChallenge13Tests
////
////  Created by Vinicius Marques on 14/05/26.
////
//
//import Testing
//@testable import ProjectChallenge13
//import CloudKit
//
//struct ItemListViewModelTesting {
//    
//    //Testing Creating
//    
//    @Test func saveItemTest()  {
//        var contaniner = CKContainer.default()
//        var database = contaniner.publicCloudDatabase
//        
//        let record = CKRecord(recordType: RecordType.itemListing.rawValue)
//        let itemListing = ItemListing(title: "asd", price: 99)
//        record.setValuesForKeys(itemListing.toDictionary())
//        database.save(record){ newRecord, error in
//            if let error = error{
//                print(error)
//            }else{
//                if let _ = newRecord{
//                    print("SAVED")
//                }
//            }
//        }
//        //buscar item e comparar com o record salvo
//        //#expect(record == fetch(xxx))
//    }
//    
//    //Testing Fetching
//    
//    @Test func saveItemTest()  {
//        var contaniner = CKContainer.default()
//        var database = contaniner.publicCloudDatabase
//        
//        let record = CKRecord(recordType: RecordType.itemListing.rawValue)
//        let itemListing = ItemListing(title: "asd", price: 99)
//        record.setValuesForKeys(itemListing.toDictionary())
//        database.save(record){ newRecord, error in
//            if let error = error{
//                print(error)
//            }else{
//                if let _ = newRecord{
//                    print("SAVED")
//                }
//            }
//        }
//        //buscar item e comparar com o record salvo
//        //#expect(record == fetch(xxx))
//    }
//    
//    //Testing Delete
//    
//    @Test func deltItemTest()  {
//        var contaniner = CKContainer.default()
//        var database = contaniner.publicCloudDatabase
//        
//        let record = CKRecord(recordType: RecordType.itemListing.rawValue)
//        let itemListing = ItemListing(title: "asd", price: 99)
//        record.setValuesForKeys(itemListing.toDictionary())
//        database.save(record){ newRecord, error in
//            if let error = error{
//                print(error)
//            }else{
//                if let _ = newRecord{
//                    print("SAVED")
//                }
//            }
//        }
//        //buscar item e comparar com o record salvo
//        //#expect(record == fetch(xxx))
//    }
//}
