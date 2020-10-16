//
//  ImageCell.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var foodImageView : UIImageView!

    var imageCache : ImageCache?
    func populate(with imagePath : String) {
        imageCache?.getImage(named: imagePath, completion: { [weak self] (image) in
            self?.foodImageView.image = image
        })
    }
}
