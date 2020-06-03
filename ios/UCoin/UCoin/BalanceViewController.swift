//
//  FirstViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 24/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {
    
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var nextIncome: UIView!
    @IBOutlet weak var dateOfIncome: UILabel!
    @IBOutlet weak var incomeSize: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var transfersBalanceLabel: UILabel!
    @IBOutlet weak var purchasesBalanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addShadows(view: nameSurname)
        addShadows(view: nextIncome)
        nextIncome.layer.cornerRadius = 10
        print(CurrentSession.user?.name ?? "user's not defined")
        
        transfersBalanceLabel.text = String(0)
        purchasesBalanceLabel.text = String(0)
        
        if let user = CurrentSession.user {
            nameSurname.text = user.name + "\n" + user.surname!
            emailLabel.text = user.email
            transfersToAdd = user.activeBalance ?? 0
            transfersBalance = transfersToAdd
            purchasesToAdd = user.passiveBalance ?? 0
            purchasesBalance = purchasesToAdd
        }
    }
    var transfersBalance : Int32!
    var transfersToAdd : Int32!
    var purchasesBalance : Int32!
    var purchasesToAdd : Int32!
    
    override func viewDidAppear(_ animated: Bool) {
        _ = Timer.scheduledTimer(timeInterval: 0.3 / Double(transfersBalance),
        target: self,
        selector: #selector(countTransferBalance),
        userInfo: nil,
        repeats: true)
        
        _ = Timer.scheduledTimer(timeInterval: 0.3 / Double(purchasesBalance),
        target: self,
        selector: #selector(countPurchasesBalance),
        userInfo: nil,
        repeats: true)
    }
    
    @objc func countTransferBalance() {
        if (transfersToAdd > -1) {
            transfersBalanceLabel.text = String(transfersBalance - transfersToAdd)
            transfersToAdd -= 1
            //purchasesBalanceLabel.text
        }
    }
    
    @objc func countPurchasesBalance() {
        if (purchasesToAdd > -1) {
            purchasesBalanceLabel.text = String(purchasesBalance - purchasesToAdd)
            purchasesToAdd -= 1
        }
    }
    
    private func addShadows(view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
}

