//
//  UIViewController+Alert.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 19/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func present(in vc: UIViewController, animated flag: Bool = true, completion handler: (()->Void)? = nil){
        vc.present(self, animated: flag, completion: handler)
    }
    
    func alert(title: String, message: String = ""){
        let alertCtr = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCtr.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        alertCtr.present(in: self)
    }
    
}
