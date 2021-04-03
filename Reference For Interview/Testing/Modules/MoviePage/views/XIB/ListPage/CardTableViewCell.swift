//
//  CardTableViewCell.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import UIKit
import Cosmos

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: MaterialCard!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var ratings: CosmosView!
    
    var viewModel : TableViewCellVM?
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.image = UIImage(named: ImageName.placeholder);
        self.contentView.backgroundColor = Theme.defaultBackgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(vm : TableViewCellVM?, indexPath: IndexPath) {
        viewModel = vm;
        guard let url = URL(string: ApiUrlConstants.imageUrl + viewModel!.getPosterPath()), let viewModel = self.viewModel else {return};
        movieImage.image = nil;
        movieImage.load(url: url);
        name.text = viewModel.getOriginalTitle();
        ratings.rating = viewModel.getVoteAverage();
    }
    
}
