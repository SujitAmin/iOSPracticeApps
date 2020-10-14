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

    func populate(with imagePath : String) {
        let url = URL(string: imagePath)!
        do {
            let data = try Data(contentsOf: url)
            foodImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
    }
}
