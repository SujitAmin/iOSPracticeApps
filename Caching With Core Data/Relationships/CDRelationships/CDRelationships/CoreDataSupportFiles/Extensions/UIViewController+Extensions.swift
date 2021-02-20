//
//  UIViewController+Extensions.swift
//  CDRelationships
//
//  Created by SujitAmin on 20/02/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
