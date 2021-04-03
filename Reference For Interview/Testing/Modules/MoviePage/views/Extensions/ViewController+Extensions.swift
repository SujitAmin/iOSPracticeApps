//
//  ViewController+Extensions.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import Foundation
import UIKit

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return noOfSections;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getCount() ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellName.cardView) as! CardTableViewCell
        if let vm = viewModel?.listViewModel?[indexPath.row] {
            cell.configureCell(vm: vm, indexPath: indexPath)
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row;
        performSegue(withIdentifier: SegueConstants.detailPage, sender: self);
    }
}
