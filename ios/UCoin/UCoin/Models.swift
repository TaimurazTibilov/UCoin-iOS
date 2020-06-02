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
    var activeBalance: Int32?
    var passiveBalance : Int32?
    var id : Int64!
    var email: String?
    var surname: String?
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

class Transaction {
    var amount : Int32
    var transactionType : TransactionType
    var accountType : AccountType
    var description : String
    init(amount: Int32, transactionType :TransactionType, accountType :AccountType, description :String) {
        self.amount = amount
        self.transactionType = transactionType
        self.accountType = accountType
        self.description = description
    }
}

enum TransactionType {
    case outgoingTransfer
    case incomingTransfer
    case shopPurchase
}

enum AccountType {
    case forTranfers
    case forPurchases
    case forTransfersAndForPurchases
}


