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
    @IBOutlet weak var transactionBalance: UILabel!
    @IBOutlet weak var activeBalance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        addShadows(view: nameSurname)
        addShadows(view: nextIncome)
        nextIncome.layer.cornerRadius = 10
        print(CurrentSession.user?.name ?? "user's not defined")
    }
    
    private func addShadows(view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
}

