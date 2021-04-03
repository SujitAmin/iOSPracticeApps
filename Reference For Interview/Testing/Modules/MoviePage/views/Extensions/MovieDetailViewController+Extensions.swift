//
//  MovieDetailViewController.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import Foundation
import UIKit

extension MovieDetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellName.imageViewCell) as! ImageTableViewCell
            cell.configureCell(viewModel: viewModel);
            return cell;
        }
        if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellName.textViewCell) as! TextTableViewCell
            cell.configureCell(viewModel: viewModel);
            return cell;
        }
        return UITableViewCell();
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections;
    }
}
