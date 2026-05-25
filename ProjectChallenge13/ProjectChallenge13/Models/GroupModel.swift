//
//  itemListing.swift
//  PocCloudKit
//
//  Created by Vinicius Marques on 13/05/26.
//

import Foundation
import CloudKit

struct CategoryModel: Codable, Hashable {
    let name: String
}

struct ActivitiesModel: Codable {
    let name: String
    let votos: Int
}

struct EventGroup{
    
    var recordId: CKRecord.ID?
    var users: Set<String>
    var categories: [CategoryModel]
    var activities: [ActivitiesModel]
    var dates: [Date]
    
    init(recordId: CKRecord.ID, users: Set<String>, categories: [CategoryModel], activities: [ActivitiesModel], dates: [Date]) {
        self.recordId = recordId
        self.users = users
        self.categories = categories
        self.activities = activities
        self.dates = dates
    }
    
    func toDictionary() -> [String: Any]{
        do{
            let categoriesData = try JSONEncoder().encode(categories)
            let activitiesData = try JSONEncoder().encode(activities)
            return ["categories": categoriesData, "activities": activitiesData, "dates": dates, "users": Array(users)]
        }catch{
            print("Erro ao codificar:", error.localizedDescription)
            return ["Erro ao codificar" : error.localizedDescription]
        }
    }
    
    static func fromRecord(_ record: CKRecord) -> EventGroup? {
        
        guard let categoriesData = record.value(forKey: "categories") as? Data, let activitiesData = record.value(forKey: "activities") as? Data, let users = record.value(forKey: "users") as? [String], let dates = record.value(forKey: "dates") as? [Date]
        else{
            return nil
        }
        
        let categories = try? JSONDecoder()
                        .decode([CategoryModel].self, from: categoriesData)

                    let activities = try? JSONDecoder()
                        .decode([ActivitiesModel].self, from: activitiesData)
        
        return EventGroup(recordId: record.recordID, users: Set(users), categories: categories ?? [], activities: activities ?? [], dates: dates)
    }
}
