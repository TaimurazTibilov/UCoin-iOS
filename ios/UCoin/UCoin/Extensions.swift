//
//  Extensions.swift
//  UCoin
//
//  Created by Renat Nurtdinov on 26.05.2020.
//  Copyright © 2020 Taimuraz Tibilov. All rights reserved.
//

import UIKit

extension UIImageView{
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
    }
}
