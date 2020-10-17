//
//  TodoViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Protocols
protocol TodoViewDelegate : class {
    func onAddTodoItem()
    func onTodoDelete(todoId: String)
    func onTodoDone(todoId: String)
}

protocol TodoViewPresentable {
    var newTodoValue : String? { get }
}

//MARK:- Class TodoViewModel
class TodoViewModel : TodoViewPresentable {
    var newTodoValue: String?
    var newTodoItem : String?
    weak var view : TodoView?
    var items : [TodoItemPresentable] = []
    
    init(view : TodoView) {
        self.view = view
        let item1 = TodoItemViewModel(id: "1", textValue : "Washing Clothes", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue : "Buy Grocieries", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue : "Wash Car", parentViewModel: self)
        items.append(contentsOf: [item1, item2, item3])
    }
    
    
}

//MARK:- Extension
extension TodoViewModel : TodoViewDelegate {
    func onTodoDone(todoId: String) {
        print("Todo Item done with id = \(todoId)")
        guard let index = self.items.index(where:  {$0.id! == todoId}) else {
            print("Index: does not exist")
            return
        }
        var todoItem = self.items[index]
        todoItem.isDone = !(todoItem.isDone)!
        if var doneMenuItem = todoItem.menuItems?.filter({ (todoMenuItem) -> Bool in
            todoMenuItem is DoneMenuItemViewModel
        }).first {
            doneMenuItem.title = todoItem.isDone! ? "Undone" : "Done"
        }
        
        self.items.sort(by: {
            if !($0.isDone!) && !($1.isDone!) {
                return $0.id! < $1.id!
            }
            if $0.isDone! && $1.isDone! {
                return $0.id! < $1.id!
            }
            return !($0.isDone!) && $1.isDone!
        })
        self.view?.reloadItems()
    }
    
    func onAddTodoItem() {
        guard let newValue = newTodoItem else {return}
        let newIndex = items.count + 1
        let item = TodoItemViewModel(id: "\(newIndex)", textValue: newValue, parentViewModel: self)
        items.append(contentsOf: [item])
        self.newTodoItem = ""
        self.view?.insertTodoItem()
    }
    func onTodoDelete(todoId: String) {
        guard let index = self.items.index(where:  {$0.id! == todoId}) else {
            print("Index: does not exist")
            return
        }
        self.items.remove(at: index)
        self.view?.removeTodoItem(index: index)
    }
}

