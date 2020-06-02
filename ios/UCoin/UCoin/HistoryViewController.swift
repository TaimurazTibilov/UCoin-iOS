//
//  SecondViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 24/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of transactions which are to be shown in history
        let numberOfRows = 3
        if (numberOfRows == 0) {
            noOperationsLabel.isHidden = false
        }
        else {
            noOperationsLabel.isHidden = true
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "operationCell") as! OperationTableViewCell
        
        
        //configure cell (pass values to its fields)
        switch indexPath.row {
        case 0:
            cell.operationDescription = "Исходящий"
            cell.operationType = .outgoingTransfer
            cell.operationAmount = 787
            cell.operationAccount = .forTranfers
        case 1:
            cell.operationDescription = "Входящий"
            cell.operationType = .incomingTransfer
            cell.operationAmount = 777
            cell.operationAccount = .forPurchases
        case 2:
            cell.operationDescription = "Покупка"
            cell.operationType = .shopPurchase
            cell.operationAmount = 737
            cell.operationAccount = .forPurchases
        default:
            cell.operationDescription = "Unknown"
        }
        
        
        cell.layoutSubviews()
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noOperationsLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(OperationTableViewCell.self, forCellReuseIdentifier: "operationCell")
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}

