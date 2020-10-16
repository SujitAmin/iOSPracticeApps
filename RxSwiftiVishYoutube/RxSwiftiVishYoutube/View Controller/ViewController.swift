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
    func removeTodoItem(index: Int)
    func updateTodoItem(index: Int)
    func reloadItems()
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
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel?.onAddTodoItem()
            
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemViewModel = viewModel?.items[indexPath.row]
        var menuActions : [UIContextualAction] = []
        _ = itemViewModel?.menuItems?.map({ menuItem in
            let menuAction = UIContextualAction(style: .normal, title: menuItem.title) { (action, sourceView, success: (Bool) -> Void) in
                if let delegate = menuItem as? TodoMenuItemViewDelegate {
                    DispatchQueue.global(qos: .userInitiated).async {
                        //  self.viewModel?.onDeleteItem(todoId: (itemViewModel?.id)!)
                        delegate.onMenuItemSelected()
                    }
                }
                success(true)
            }
            
            menuAction.backgroundColor = menuItem.backColor?.hexColor
            menuActions.append(contentsOf: [menuAction])
        })
        return UISwipeActionsConfiguration(actions: menuActions)
    }
    
}
extension ViewController : TodoView {
    func updateTodoItem(index: Int) {
        DispatchQueue.main.async {
            self.tableViewItems.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
    }
    
    func removeTodoItem(index: Int) {
        DispatchQueue.main.async {
            self.tableViewItems.beginUpdates()
            self.tableViewItems.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            self.tableViewItems.endUpdates()
        }
    }
    
    
    func insertTodoItem() {
        guard let items = viewModel?.items else { return }
        DispatchQueue.main.async { [weak self] in
            self?.textFieldNewItem.text = self?.viewModel?.newTodoItem!
            
            self?.tableViewItems.beginUpdates()
            self?.tableViewItems.insertRows(at: [IndexPath(row: items.count - 1, section: 0)], with: .automatic)
            self?.tableViewItems.endUpdates()
        }
        
    }
    
    func reloadItems() {
        DispatchQueue.main.async {
            self.tableViewItems.reloadData()
        }
    }
    
}
