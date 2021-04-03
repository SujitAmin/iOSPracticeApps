//
//  TextTableViewCell.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contents: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contents.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(viewModel : DetailsVM?) {
        title.text = viewModel?.getTitle() ?? ""
        contents.text = viewModel?.getOverview() ?? "";
    }
    
}
