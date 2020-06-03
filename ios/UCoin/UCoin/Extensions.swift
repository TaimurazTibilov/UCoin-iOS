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

extension UIViewController {
    class func displaySpinner(onView : UIView, darkenBack : Bool) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        if darkenBack {
            spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        }
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
