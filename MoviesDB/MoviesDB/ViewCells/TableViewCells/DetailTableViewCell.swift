//
//  DetailTableViewCell.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var textDetail: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
