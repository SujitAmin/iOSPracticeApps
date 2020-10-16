//
//  FoodTypesTableViewCell.swift
//  InstagramFeed
//
//  Created by SujitAmin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FoodTypesTableViewCell: UITableViewCell {

    @IBOutlet weak var foodTypeImageView : UIImageView!
    @IBOutlet weak var foodTypeLabel : UILabel!
    
    var imageCache : ImageCache?
    
    func populateCell(with foodType: FoodType) {
        foodTypeLabel.text = foodType.title
        imageCache?.getImage(named: foodType.mainImagePath, completion: { [weak self] (image) in
            self?.foodTypeImageView.image = image
        })
    }

}
