//
//  LoginViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 24/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.layer.shadowColor = UIColor.darkGray.cgColor
        boardView.layer.shadowOpacity = 10
        boardView.layer.shadowOffset = .zero
        boardView.layer.shadowRadius = 10
        
        styleTextField(textField: email)
        styleTextField(textField: password)
        
        signInButton.layer.cornerRadius = 10
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func styleTextField(textField: UITextField)
    {
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.clear.cgColor
        
        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 4.0
        textField.layer.shadowOffset = .zero
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        view.endEditing(true)
        if (!(email.text?.isEmpty ?? true) && !(password.text?.isEmpty ?? true)) {
            let parameters: [String: Any] = ["email" : email.text!, "password" : password.text!]
            
            // create post request
            let url = URL(string: "http://renurtt.pythonanywhere.com/user/obtain_token/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
            catch {
                print("Error: \(error)")
                displayErrorMessage(message: "Что-то пошло не так")
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let vc = UIViewController.displaySpinner(onView: self.view, darkenBack: true)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
                
                if let httpResponse = response as? HTTPURLResponse {
                    if (httpResponse.statusCode == 500) {
                        self.displayErrorMessage(message: "Неверный логин или пароль")
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
                        if let responseJSON = responseJSON as? [String: Any] {
                            CurrentSession.user = User(name: responseJSON["name"] as! String, accessToken: responseJSON["token"] as! String)
                            
                            
                            let name = CurrentSession.user!.name.components(separatedBy: " ")[0]
                            
                            let url = URL(string: "http://renurtt.pythonanywhere.com/user/" + name + "/")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "GET"
                            
                            let task1 = URLSession.shared.dataTask(with: request) { data, response, error in
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
                                        if let responseJSON = responseJSON as? [String: Any] {
                                            CurrentSession.user?.id = (responseJSON["id"] as! Int64)
                                            CurrentSession.user?.surname = (responseJSON["surname"] as! String)
                                            CurrentSession.user?.name = (responseJSON["name"] as! String)
                                            CurrentSession.user?.activeBalance = (responseJSON["active_balance"] as! Int32)
                                            CurrentSession.user?.passiveBalance = (responseJSON["passive_balance"] as! Int32)
                                            CurrentSession.user?.email = (responseJSON["email"] as! String)
                                        }
                                        
                                        DispatchQueue.main.async {
                                            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabViewController") as? UITabBarController {
                                                vc.modalPresentationStyle = .fullScreen
                                                vc.modalTransitionStyle = .coverVertical
                                                
                                                self.present(vc, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    else {
                                        self.displayErrorMessage(message: "Не удалось получить информацию о пользователе")
                                    }
                                }
                            }
                            task1.resume()
                        }
                    }
                }
                UIViewController.removeSpinner(spinner: vc)
            }
            task.resume()
        }
        else {
            displayErrorMessage(message: "Введите логин и пароль")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
