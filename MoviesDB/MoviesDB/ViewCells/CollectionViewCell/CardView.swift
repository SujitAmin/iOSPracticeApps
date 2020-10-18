//
//  CardView.swift
//  MoviesDB
//
//  Created by SujitAmin on 18/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CardView: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var outerView: CardViewLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.image = UIImage(named: Constants.ImageNames.launchImage)
    }
    
    override func layoutSubviews() {
        self.layoutIfNeeded()
    }
    
    
}
