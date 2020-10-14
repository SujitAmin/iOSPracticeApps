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
    
    func populateCell(with foodType: FoodType) {
        foodTypeLabel.text = foodType.title
    }

}
