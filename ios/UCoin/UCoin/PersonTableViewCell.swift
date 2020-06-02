//
//  PersonViewCell.swift
//  UCoin
//
//  Created by Taimuraz Tibilov on 30/05/2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var email: UILabel!
    var name: String?
    var mail: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        personName.text = name
        email.text = mail
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
