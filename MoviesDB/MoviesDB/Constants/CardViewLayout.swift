//
//  CardViewLayout.swift
//  MoviesDB
//
//  Created by SujitAmin on 18/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class CardViewLayout: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10

    @IBInspectable var shadowOffsetWidth: Int = 10
    @IBInspectable var shadowOffsetHeight: Int = 10
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.2

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}
