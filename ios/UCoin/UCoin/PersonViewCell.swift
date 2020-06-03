//
//  PersonViewCell.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 30/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class PersonViewCell: UITableViewCell {
    var personName : String?
    var email : String?

    var personNameView : UILabel  = {
        let personNameView = UILabel()
        
        personNameView.font = UIFont.init(name: "Thonburi", size: 20)
        personNameView.textAlignment = NSTextAlignment.left
        
        personNameView.translatesAutoresizingMaskIntoConstraints = false
        personNameView.isUserInteractionEnabled = false
        
        return personNameView
    }()

    var emailView : UILabel = {
        let emailView = UILabel()
        
        emailView.font = UIFont.init(name: "Thonburi", size: 16)
        emailView.textAlignment = NSTextAlignment.left
        
        emailView.textColor = UIColor.darkGray
        emailView.translatesAutoresizingMaskIntoConstraints = false
        emailView.isUserInteractionEnabled = false
        
        return emailView
    }()
    
    var greaterThanImage : UIImageView  = {
        let greaterThanImage = UIImageView()
        greaterThanImage.translatesAutoresizingMaskIntoConstraints = false
        greaterThanImage.isUserInteractionEnabled = false
        greaterThanImage.image = UIImage(systemName: "greaterthan.circle")
        greaterThanImage.tintColor = UIColor.init(red: 224/255, green: 0, blue: 0, alpha: 1)
        
        return greaterThanImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(personNameView)
        self.addSubview(greaterThanImage)
        self.addSubview(emailView)
        
        //transparent back
        self.backgroundColor = UIColor.init(red: 256/256, green: 256/256, blue: 256/256, alpha: 1.0)
        
        personNameView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        personNameView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        
        greaterThanImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        greaterThanImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //greaterThanImage.leftAnchor.constraint(equalTo: self.personNameView.rightAnchor).isActive = true
        greaterThanImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        greaterThanImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        emailView.rightAnchor.constraint(equalTo: self.personNameView.rightAnchor).isActive = true
        emailView.leftAnchor.constraint(equalTo: self.personNameView.leftAnchor).isActive = true
        
        sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if let personName = personName {
            personNameView.text = personName
        }
        if let email = email {
            emailView.text = email
        }
    }
}
