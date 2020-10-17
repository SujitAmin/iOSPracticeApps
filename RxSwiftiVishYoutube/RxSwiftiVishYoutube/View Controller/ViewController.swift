//
//  ViewController.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

//MARK:- Protocols
protocol TodoView : class {
    func insertTodoItem()
    func removeTodoItem(index: Int)
    func updateTodoItem(index: Int)
    func reloadItems()
}

//MARK:- Class ViewController
class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewItems: UITableView!
    @IBOutlet weak var textFieldNewItem: UITextField!
    
    var viewModel : TodoViewModel?
    let cellIdentifier = "todoItemCellIdentifier"
    let nibTodoItemCell = "TodoItemTableViewCell"
    
    fileprivate func setUpTableView() {
        tableViewItems.dataSource = self
        tableViewItems.delegate = self
        let nib = UINib(nibName: nibTodoItemCell, bundle: nil)
        tableViewItems.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        viewModel = TodoViewModel(view: self)
    }
    
    @IBAction func onAddItem(_ sender: UIButton) {
        guard let newTodoTextValue = textFieldNewItem.text else { return }
        viewModel?.newTodoItem = newTodoTextValue
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel?.onAddTodoItem()
        }
    }
}

//MARK:- Extension
extension ViewController :  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoItemTableViewCell
        guard let itemViewModel = viewModel?.items[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(withViewModel: itemViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel?.items[indexPath.row] as? TodoItemViewDelegate
        itemViewModel?.onItemSelected()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemViewModel = viewModel?.items[indexPath.row]
        var menuActions : [UIContextualAction] = []
        _ = itemViewModel?.menuItems?.map({ menuItem in
            let menuAction = UIContextualAction(style: .normal, title: menuItem.title) { (action, sourceView, success: (Bool) -> Void) in
                if let delegate = menuItem as? TodoMenuItemViewDelegate {
                    DispatchQueue.global(qos: .userInitiated).async {
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
