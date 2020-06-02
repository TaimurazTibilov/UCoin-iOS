//
//  OperationTableViewCell.swift
//  UCoin
//
//  Created by Renat Nurtdinov on 26.05.2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

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

class OperationTableViewCell: UITableViewCell {
    
    var operationDescription : String?
    var operationType : TransactionType?
    var operationAmount : Int32?
    var operationAccount : AccountType?
    
    var descriptionView : UILabel = {
        var descriptionView = UILabel()
        
        descriptionView.font = UIFont.init(name: "Thonburi", size: 20)
        descriptionView.textAlignment = NSTextAlignment.justified
        descriptionView.textColor = UIColor.black
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.isUserInteractionEnabled = false
        
        return descriptionView
    }()
    
    var typeImage : UIImageView  = {
        var typeImage = UIImageView()
        typeImage.backgroundColor = UIColor.init(red: 224/255, green: 0, blue: 0, alpha: 1)
        typeImage.translatesAutoresizingMaskIntoConstraints = false
        typeImage.isUserInteractionEnabled = false
        
        return typeImage
    }()
    
    var amountView : UILabel  = {
        var amountView = UILabel()
        amountView.font = UIFont.init(name: "Thonburi-Bold", size: 22)
        amountView.textAlignment = NSTextAlignment.right
        
        amountView.translatesAutoresizingMaskIntoConstraints = false
        amountView.isUserInteractionEnabled = false
        
        return amountView
    }()
    
    var accountTypeView : UILabel  = {
        var accountType = UILabel()
        accountType.font = UIFont.init(name: "Thonburi", size: 10)
        accountType.textAlignment = NSTextAlignment.right
        accountType.textColor = UIColor.gray
        
        accountType.translatesAutoresizingMaskIntoConstraints = false
        accountType.isUserInteractionEnabled = false
        
        return accountType
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        self.addSubview(descriptionView)
        self.addSubview(typeImage)
        self.addSubview(amountView)
        self.addSubview(accountTypeView)
        //self.heightAnchor.constraint(equalToConstant: 90).isActive = true
        //self.sizeToFit()
        
        //transparent back
        self.backgroundColor = UIColor.init(red: 256/256, green: 256/256, blue: 256/256, alpha: 1.0)
        
        typeImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        typeImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        typeImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        typeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        descriptionView.leftAnchor.constraint(equalTo: typeImage.rightAnchor, constant: 10).isActive = true
        descriptionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: amountView.leftAnchor).isActive = true
        
        amountView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        amountView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true
        amountView.leftAnchor.constraint(equalTo: self.descriptionView.rightAnchor).isActive = true
        
        accountTypeView.topAnchor.constraint(equalTo: self.amountView.bottomAnchor,constant: 0).isActive = true
        accountTypeView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10).isActive = true
        
        
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 0.01
        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        self.contentView.layer.masksToBounds = true
        addShadows(view: contentView)
        
        sizeToFit()
    }
    
    private func addShadows(view: UIView) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let operationDescription = operationDescription {
            self.descriptionView.text = operationDescription
        }
        
        if let operationType = operationType {
            if let operationAmount = operationAmount {
                switch operationType {
                case .incomingTransfer:
                    typeImage.image = UIImage(named: "right_arrow")
                    amountView.text = "+" + String(operationAmount)
                    amountView.textColor = UIColor.systemGreen
                case .outgoingTransfer:
                    typeImage.image = UIImage(named: "left_arrow")
                    amountView.text = "-" + String(operationAmount)
                    amountView.textColor = UIColor.black
                case .shopPurchase:
                    typeImage.image = UIImage(named: "cart")
                    amountView.text = "-" + String(operationAmount)
                    amountView.textColor = UIColor.black
                }
                typeImage.asCircle()
            }
            
            if let operationAccount = operationAccount {
                if (operationAccount == .forPurchases && operationType == .incomingTransfer) {
                    accountTypeView.text = "в покупки"
                }
                if (operationAccount == .forTranfers && operationType == .incomingTransfer) {
                    accountTypeView.text = "в переводы"
                }
                if (operationAccount == .forPurchases && operationType == .shopPurchase) {
                    accountTypeView.text = "из покупок"
                }
                if (operationAccount == .forTranfers && operationType == .outgoingTransfer) {
                    accountTypeView.text = "из переводов"
                }
                if (operationAccount == .forTransfersAndForPurchases && operationType == .outgoingTransfer) {
                    accountTypeView.text = "из покупок и переводов"
                }
            }
        }
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
