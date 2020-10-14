//
//  FoodTypesDetailsViewController.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FoodTypesDetailsViewController: UITableViewController {

    var foodType: FoodType!
    var foodImagePaths : [String] {return foodType.allImagePaths}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foodImagePaths.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
        
        let imageCell = cell as? ImageCell
        let imagePath = foodImagePaths[indexPath.row]
        return cell
    }
    
}