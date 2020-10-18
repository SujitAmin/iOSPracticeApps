//
//  MyCollectionViewCell.swift
//  UiCollectionView
//
//  Created by SujitAmin on 18/10/20.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViews : UIImageView!
    
    //this is needed if we are using UICollectionViewFlowLayoutDelegate
    //Keep Estimated Size to .none
    override func layoutSubviews() {
        self.layoutIfNeeded()
        
        imageViews.layer.cornerRadius = imageViews.frame.height / 2
        imageViews.layer.masksToBounds = false
        imageViews.clipsToBounds = true
    }
}
