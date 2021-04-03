//
//  MaterialCard.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import UIKit

public class MaterialCard: UIView {
    var cornerRadius: CGFloat = 10
    var shadowOffsetWidth: Int = 0
    var shadowOffsetHeight: Int = 2
    var shadowColor: UIColor? = UIColor.black
    var shadowOpacity: Float = 0.2

    public override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
