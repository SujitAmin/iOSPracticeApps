//
//  TableViewCell.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var label : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        label.text = "";
    }

}
