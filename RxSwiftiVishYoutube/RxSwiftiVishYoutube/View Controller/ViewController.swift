//
//  ViewController.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewItems: UITableView!
    @IBOutlet weak var textFieldNewItem: UITextView!
    
    var viewModel : TodoViewModel?
    let cellIdentifier = "todoItemCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTableView()
        
        viewModel = TodoViewModel()
    }
    
    
    fileprivate func setUpTableView() {
        tableViewItems.dataSource = self
        tableViewItems.delegate = self
        let nib = UINib(nibName: "TodoItemTableViewCell", bundle: nil)
        tableViewItems.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    @IBAction func onAddItem(_ sender: UIButton) {
        
    }

}


extension ViewController :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TodoItemTableViewCell
        
        let itemViewModel = viewModel?.items[indexPath.row]
        cell?.configureCell(withViewModel: itemViewModel!)
        return cell!
    }
}
