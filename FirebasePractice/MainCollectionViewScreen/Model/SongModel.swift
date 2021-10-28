//
//  SongModel.swift
//  tableViewMusic
//
//  Created by pro2017 on 16/10/2021.
//

import Foundation
import FirebaseDatabase
import Firebase

class SongModel {
    
    let imageNumber: Int
    let name: String
    let description: String
    let userID: String
    let ref: DatabaseReference?
    
    // Инициализатор для локального создания песни
    init(imageNumber: Int, name: String, description: String, userID: String) {
        self.imageNumber = imageNumber
        self.name = name
        self.description = description
        self.userID = userID
        self.ref = nil
    }
    
    // Опциональный инициализатор для создания песни, используя данные полученные из FirebaseDatabase
    init?(snapshotValue: [String: Any], ref: DatabaseReference) {
        //guard let snapshotValue = snapshot.value as? [String: Any] else { return nil }
        guard
            let imageNumber = snapshotValue["imageNumber"] as? Int,
            let name = snapshotValue["name"] as? String,
            let description = snapshotValue["description"] as? String,
            let userID = snapshotValue["userID"] as? String
        else { return nil }
        
        self.imageNumber = imageNumber
        self.name = name
        self.description = description
        self.userID = userID
        self.ref = ref
    }
    
    func convertToDictionary() -> Any {
        return ["imageNumber": self.imageNumber, "name": self.name, "description": self.description, "userID": self.userID]
    }
}
