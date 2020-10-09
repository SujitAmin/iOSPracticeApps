//
//  DetailViewController.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var overView : String?
    var posterImageURL : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView();
    }
    func initializeTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
    }
}
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.tableViewCell , for: indexPath) as? DetailTableViewCell
        cell?.imageDetail.kf.setImage(with: URL(string: posterImageURL!)!)
        cell?.textDetail.text = overView ?? ""
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
}
