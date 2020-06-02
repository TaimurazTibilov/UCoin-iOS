//
//  PersonTransactionViewController.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 30/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class PersonTransactionViewController: UIViewController {
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tabName: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleTextField(textField: amountField)
        styleTextField(textField: commentView)
        addShadows(view: mainView)
        
        amountField.borderStyle = .roundedRect
        commentView.layer.cornerRadius = 10
    }
    
    private func addShadows(view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
    
    private func styleTextField(textField: UIView)
    {
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.clear.cgColor

        textField.layer.masksToBounds = false
        textField.layer.shadowColor = UIColor.gray.cgColor
        textField.layer.shadowOpacity = 0.5
        textField.layer.shadowRadius = 4.0
        textField.layer.shadowOffset = .zero
    }

}
