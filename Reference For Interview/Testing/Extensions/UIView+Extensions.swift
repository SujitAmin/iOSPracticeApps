//
//  UIView+Extensions.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import Foundation
import UIKit
extension UIView {
    func curvedView(radius: CGFloat) {
        self.layer.cornerRadius = radius;
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
    }
}
