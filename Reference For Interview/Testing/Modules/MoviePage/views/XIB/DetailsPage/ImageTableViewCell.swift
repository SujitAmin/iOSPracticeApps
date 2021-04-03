//
//  ImageTableViewCell.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImage : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.curvedImage(radius: 10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel : DetailsVM?) {
        guard let url = URL(string: ApiUrlConstants.imageUrl + (viewModel?.getPosterPath() ?? "")) else {return}
        movieImage.load(url: url)
    }
}
