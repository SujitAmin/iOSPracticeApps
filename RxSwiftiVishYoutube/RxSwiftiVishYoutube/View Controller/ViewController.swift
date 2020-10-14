//
//  ViewController.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol TodoView : class {
    func insertTodoItem()
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewItems: UITableView!
    @IBOutlet weak var textFieldNewItem: UITextField!
    
    var viewModel : TodoViewModel?
    let cellIdentifier = "todoItemCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        viewModel = TodoViewModel(view: self)
    }
    
    
    /// sets up tableView
    fileprivate func setUpTableView() {
        tableViewItems.dataSource = self
        tableViewItems.delegate = self
        let nib = UINib(nibName: "TodoItemTableViewCell", bundle: nil)
        tableViewItems.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    /// button "Add Item"
    /// - Parameter sender: UIButton
    @IBAction func onAddItem(_ sender: UIButton) {
        
        guard let newTodoTextValue = textFieldNewItem.text else { return }
        viewModel?.newTodoItem = newTodoTextValue
        viewModel?.onAddTodoItem()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel?.items[indexPath.row]
        (itemViewModel as? TodoItemViewDelegate)?.onItemSelected()
    }
    
}
extension ViewController : TodoView {
    func insertTodoItem() {
        guard let items = viewModel?.items else { return }
        self.textFieldNewItem.text = viewModel?.newTodoItem!
        
        self.tableViewItems.beginUpdates()
        self.tableViewItems.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
        self.tableViewItems.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .normal, title: "Remove") { (action, sourceView, success: (Bool) -> Void) in
            success(true)
        }
        removeAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
}
