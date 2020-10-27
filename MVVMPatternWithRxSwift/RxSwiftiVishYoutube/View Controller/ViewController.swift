//
//  ViewController.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//MARK:- Protocols
//protocol TodoView : class {
//    func insertTodoItem()
//    func removeTodoItem(index: Int)
//    func updateTodoItem(index: Int)
//    func reloadItems()
//}

//MARK:- Class ViewController
class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewItems: UITableView!
    @IBOutlet weak var textFieldNewItem: UITextField!
    
    var viewModel : TodoViewModel?
    let disposeBag = DisposeBag()
    let cellIdentifier = "todoItemCellIdentifier"
    let nibTodoItemCell = "TodoItemTableViewCell"
    
    lazy var searchController : UISearchController =  ({
        let controller  = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.searchBar.sizeToFit()
        controller.searchBar.barStyle = UIBarStyle.black
        controller.searchBar.barTintColor = UIColor.black
        controller.searchBar.backgroundColor = UIColor.clear
        controller.searchBar.placeholder = "Search todos...."
        return controller
    })()
    
    fileprivate func setUpTableView() {
        // tableViewItems.dataSource = self
        tableViewItems.delegate = self
        let nib = UINib(nibName: nibTodoItemCell, bundle: nil)
        tableViewItems.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        viewModel = TodoViewModel(/*view: self*/)
        
//        viewModel?.items.asObservable().bind(to: tableViewItems.rx.items(cellIdentifier: cellIdentifier, cellType: TodoItemTableViewCell.self)) {index,item,cell in
//            cell.configureCell(withViewModel: item)
//        }.disposed(by: disposeBag)
        viewModel?.filteredItems.asObservable().bind(to: tableViewItems.rx.items(cellIdentifier: cellIdentifier, cellType: TodoItemTableViewCell.self)) {index,item,cell in
            cell.configureCell(withViewModel: item)
        }.disposed(by: disposeBag)
        
        let searchBar = searchController.searchBar
        tableViewItems.tableHeaderView = searchBar
        tableViewItems.contentOffset = CGPoint(x: 0, y: 40)
        
        searchBar.rx.text.orEmpty.distinctUntilChanged().debug().bind(to: (viewModel?.searchValue)!).disposed(by: disposeBag)
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
//extension ViewController :  UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel?.items.value.count ?? 0
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TodoItemTableViewCell
//        guard let itemViewModel = viewModel?.items.value[indexPath.row] else { return UITableViewCell() }
//        cell.configureCell(withViewModel: itemViewModel)
//        return cell
//    }
//}
    
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemViewModel = viewModel?.items.value[indexPath.row] as? TodoItemViewDelegate
        itemViewModel?.onItemSelected()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let itemViewModel = viewModel?.items.value[indexPath.row]
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
//extension ViewController : TodoView {
//    func updateTodoItem(index: Int) {
//        DispatchQueue.main.async {
//            self.tableViewItems.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//        }
//    }
//    
//    func removeTodoItem(index: Int) {
//        DispatchQueue.main.async {
//            self.tableViewItems.beginUpdates()
//            self.tableViewItems.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
//            self.tableViewItems.endUpdates()
//        }
//    }
//    
//    func insertTodoItem() {
//        guard let items = viewModel?.items else { return }
//        DispatchQueue.main.async { [weak self] in
//            self?.textFieldNewItem.text = self?.viewModel?.newTodoItem!
//            self?.tableViewItems.beginUpdates()
//            self?.tableViewItems.insertRows(at: [IndexPath(row: items.value.count - 1, section: 0)], with: .automatic)
//            self?.tableViewItems.endUpdates()
//        }
//
//    }
//    
//    func reloadItems() {
//        DispatchQueue.main.async {
//            self.tableViewItems.reloadData()
//        }
//    }
//}
