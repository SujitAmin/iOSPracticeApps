//
//  ViewController.swift
//  InstagramFeed
//
//  Created by SujitAmin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class FoodTypesViewController: UITableViewController {

    var foodTypes : Array = [FoodType]()
    
    let cellIdentifier = "FoodTypeCell"
    let NUMBER_OF_SECTIONS = 1
    
    let firestore = FirestoreService.shared
    let imageCache = ImageCache()
    
    fileprivate func setUpTableView() {
        tableView.rowHeight = tableView.frame.width * 8/15
        tableView.delegate = self
        tableView.dataSource = self
    }
    fileprivate func loadData() {
        firestore.listen { [weak self] (foodTypes) in
            self?.hideIndicator()
            self!.foodTypes = foodTypes
            self!.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore.configure()
        setUpTableView()
        showIndicator(withTitle: "Loading...", and: "Fetching Images...")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_SECTIONS
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let foodTypeCell = cell as? FoodTypesTableViewCell
        foodTypeCell?.imageCache = imageCache
        let foodType = foodTypes[indexPath.row]
        foodTypeCell?.populateCell(with: foodType)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodType = foodTypes[indexPath.row]
        performSegue(withIdentifier: "segue", sender: foodType)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newFoodTypeVC = segue.destination as? NewFoodTypeViewController {
            newFoodTypeVC.firestore = firestore
        } else if let foodTypeDetailsVC = segue.destination as? FoodTypesDetailsViewController, let foodType = sender as? FoodType {
            foodTypeDetailsVC.foodType = foodType
            foodTypeDetailsVC.imageCache = imageCache
        }
    }
}

