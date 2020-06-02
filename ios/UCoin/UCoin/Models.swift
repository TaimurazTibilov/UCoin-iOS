//
//  Models.swift
//  UCoin
//
//  Created by Renat Nurtdinov on 31.05.2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class User {
    var name : String
    var accessToken : String
    init(name: String, accessToken : String) {
        self.name = name
        self.accessToken = accessToken
    }
}

class CurrentSession {
    static var user : User?
}

class Person {
    var name: String
    var surname: String
    var id: Int
    var email: String
    
    init(name: String, surname: String, id: Int, email: String) {
        self.email = email
        self.id = id
        self.surname = surname
        self.name = name
    }
}
