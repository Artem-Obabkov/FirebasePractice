//
//  UserModel.swift
//  tableViewMusic
//
//  Created by pro2017 on 18/10/2021.
//

import Foundation
import Firebase
import FirebaseDatabase

struct CurrentUser {
    
    let uid: String
    let email: String
    let name: String
    
    // Инициализируем с помошью User из Firebase
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
        self.name = user.displayName!
    }
    
    init?(currentUserData: [String: Any], uid: String) {
        let email = currentUserData["email"] as! String
        let name = currentUserData["displayName"] as! String
        
        self.name = name
        self.email = email
        self.uid = uid
    }
    
}
