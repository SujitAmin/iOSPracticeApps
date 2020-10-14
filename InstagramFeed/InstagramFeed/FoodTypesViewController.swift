//
//  ViewController.swift
//  InstagramFeed
//
//  Created by SujitAmin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FoodTypesViewController: UITableViewController {

    var foodTypes : Array = [FoodType]()
    
    let cellIdentifier = "FoodTypeCell"
    
    let firestore = FirestoreService.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = tableView.frame.width * 8/15
        firestore.listen { [weak self] (foodTypes) in
            self?.foodTypes = foodTypes
            self?.tableView.reloadData()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return foodTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let foodTypeCell = cell as? FoodTypesTableViewCell
        let foodType = foodTypes[indexPath.row]
        foodTypeCell?.populateCell(with: foodType)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newFoodTypeVC = segue.destination as? NewFoodTypeViewController {
            newFoodTypeVC.firestore = firestore
        } else if let foodTypeDetailsVC = segue.destination as? FoodTypesDetailsViewController, let foodType = sender as? FoodType {
            foodTypeDetailsVC.foodType = foodType
        }
    }
}

