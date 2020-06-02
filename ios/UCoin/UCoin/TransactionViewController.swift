//
//  TransactionViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 24/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var personsTable: UITableView!
    @IBOutlet weak var findByNameField: UITextField!
    
    
    @IBAction func surnameChanged(_ sender: Any) {
    }
    
    var personsToSend: [Person]!
    var cellReuseId = "personCell"
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personsToSend.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personsTable.dequeueReusableCell(withIdentifier: cellReuseId, for: indexPath) as! PersonTableViewCell
        
        cell.name = personsToSend[indexPath.row].name + " " + personsToSend[indexPath.row].surname
        cell.mail = personsToSend![indexPath.row].email
        addShadows(view: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.personsToSend = []
        initializeData()
        
        //debug version
        personsToSend?.append(Person(name: "Ренат", surname: "Нуртдинов", id: 5, email: "ranurtdinov@edu.hse.ru"))
        
        personsTable.register(PersonTableViewCell.self, forCellReuseIdentifier: cellReuseId)
        personsTable.dataSource = self
        personsTable.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addShadows(view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
    
    func initializeData() {
        let url = URL(string: "http://renurtt.pythonanywhere.com/user/users/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // insert json data to the request
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: [], options: .prettyPrinted)
//        }
//        catch {
//            print("Error: \(error)")
//            displayErrorMessage(message: "Что-то пошло не так")
//        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                if (httpResponse.statusCode == 500) {
                    self.displayErrorMessage(message: "Невозможно загрузить пользователей")
                }
                else if (httpResponse.statusCode == 200) {
                    var responseJSON : (Any)? = nil
                    do {
                        responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    }
                    catch {
                        print("Error: \(error)")
                        self.displayErrorMessage(message: "Что-то пошло не так")
                    }
                    if let responseJSON = responseJSON as? [Any] {
                        for case let personJSON as [String: Any] in responseJSON {
                            self.personsToSend?.append(Person(name: personJSON["name"] as! String, surname: personJSON["surname"] as! String, id: personJSON["id"] as! Int, email: personJSON["email"] as! String))
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func displayErrorMessage(message:String) {
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            }
            alertView.addAction(OKAction)
            if let presenter = alertView.popoverPresentationController {
                presenter.sourceView = self.view
                presenter.sourceRect = self.view.bounds
            }
            self.present(alertView, animated: true, completion:nil)
        }
    }
    
}
