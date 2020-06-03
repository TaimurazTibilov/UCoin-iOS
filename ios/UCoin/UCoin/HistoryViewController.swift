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
        let numberOfRows = transactions.count
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
        /*
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
         */
        cell.operationDescription = transactions[indexPath.row].description
        cell.operationType = transactions[indexPath.row].transactionType
        cell.operationAmount = transactions[indexPath.row].amount
        cell.operationAccount = transactions[indexPath.row].accountType
        
        
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
        loadData()
    }
    
    var transactions = [Transaction]()
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
    func loadData() {
        
        // create post request
        //let url = URL(string: "http://renurtt.pythonanywhere.com/transactions/receiver_history" + String(CurrentSession.user?.id as! Int64) + "/")!
        if CurrentSession.user != nil {
            let url = URL(string: "http://renurtt.pythonanywhere.com/transactions/receiver_history/" + String(CurrentSession.user!.id)  + "/")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let vc = UIViewController.displaySpinner(onView: self.view, darkenBack: false)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 200) {
                        var responseJSON : (Any)? = nil
                        do {
                            responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        }
                        catch {
                            print("Error: \(error)")
                        }
                        if let responseJSON = responseJSON as? [[String: Any]] {
                            for tr in responseJSON {
                                let vs = (tr["amount"] as! String).components(separatedBy: ".")[0]
                                let v =  Int32(vs)
                                self.transactions.append(Transaction(amount: v ?? 0, transactionType: .incomingTransfer, accountType: .forPurchases, description: tr["description"] as! String))
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                            }
                        }
                    }
                }
            }
            
            task.resume()
            
            let url1 = URL(string: "http://renurtt.pythonanywhere.com/transactions/sender_history/" + String(CurrentSession.user!.id) + "/")!
            var request1 = URLRequest(url: url1)
            request1.httpMethod = "GET"
            
            let task1 = URLSession.shared.dataTask(with: request1) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 200) {
                        var responseJSON : (Any)? = nil
                        do {
                            responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        }
                        catch {
                            print("Error: \(error)")
                        }
                        if let responseJSON = responseJSON as? [[String: Any]] {
                            for tr in responseJSON {
                                let typeTr : TransactionType
                                let typeAc : AccountType
                                if (tr["is_purchase"] as! Bool) {
                                    typeTr = .shopPurchase
                                    typeAc = .forPurchases
                                }
                                else {
                                    typeTr = .outgoingTransfer
                                    typeAc = .forTranfers
                                }
                                
                                let vs = (tr["amount"] as! String).components(separatedBy: ".")[0]
                                let v =  Int32(vs)
                                self.transactions.append(Transaction(amount: v ?? 0, transactionType: typeTr, accountType: typeAc, description: tr["description"] as! String))
                                
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                            }
                        }
                    }
                }
                UIViewController.removeSpinner(spinner: vc)
            }
            
            task1.resume()
        }
    }
}

