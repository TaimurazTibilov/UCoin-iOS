//
//  RegistrationViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 24/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repeatPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationView.layer.shadowColor = UIColor.darkGray.cgColor
        registrationView.layer.shadowOpacity = 10
        registrationView.layer.shadowOffset = .zero
        registrationView.layer.shadowRadius = 10
        
        styleTextField(textField: emailField)
        styleTextField(textField: passwordField)
        styleTextField(textField: repeatPasswordField)
        
        registerButton.layer.cornerRadius = 10
        
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if let firstViewController = self.navigationController?.viewControllers.first {
            self.navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
    
}
