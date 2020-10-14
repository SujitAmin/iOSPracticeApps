//
//  TodoViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol TodoMenuItemViewPresentable {
    var title : String? { get }
    var backColor : String? { get }
}

protocol TodoMenuItemViewDelegate  {
    func onMenuItemSelected()
}

class TodoMenuItemViewModel : TodoMenuItemViewPresentable, TodoMenuItemViewDelegate {
    func onMenuItemSelected() {
        //base class does not require any implementation
    }
    var title: String?
    var backColor: String?
    weak var parent : TodoItemViewDelegate?
    
    init(parentViewModel: TodoItemViewDelegate) {
        self.parent = parentViewModel
    }
    
}
class RemoveMenuItemViewModel: TodoMenuItemViewModel {
    override func onMenuItemSelected() {
         print("Remove item selected")
        parent?.onRemoveSelected()
    }
}

class  DoneMenuItemViewModel : TodoMenuItemViewModel {
    override func onMenuItemSelected() {
        print("Done item selected")
        parent?.onDoneSelected()
    }
}

protocol TodoItemViewDelegate : class {
    func onItemSelected()
    func onRemoveSelected()
    func onDoneSelected()
}

protocol TodoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
    var menuItems : [TodoMenuItemViewPresentable]? { get }
}

class TodoItemViewModel : TodoItemPresentable{
    var menuItems: [TodoMenuItemViewPresentable]? = []
    var id: String? = "0"
    var textValue: String?
    weak var parent: TodoViewDelegate?
    
    
    init(id: String, textValue : String, parentViewModel : TodoViewDelegate) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self)
        removeMenuItem.title = "Remove"
        removeMenuItem.backColor = "ff0000"
        
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = "Done"
        doneMenuItem.backColor = "000000"
        
        menuItems?.append(contentsOf: [removeMenuItem, doneMenuItem])
    }
}

extension TodoItemViewModel : TodoItemViewDelegate {
    func onRemoveSelected() {
        parent?.onTodoDelete(todoId: id!)
    }
    
    func onDoneSelected() {
        parent?.onTodoDone(todoId: id!)
    }
    
    func onItemSelected() {
        
    }
}

protocol TodoViewDelegate : class {
    func onAddTodoItem()
    func onTodoDelete(todoId: String)
    func onTodoDone(todoId: String)
}

protocol TodoViewPresentable {
    var newTodoValue : String? { get }
}

class TodoViewModel : TodoViewPresentable {
    var newTodoValue: String?
    var newTodoItem : String?
    weak var view : TodoView?
    init(view : TodoView) {
        self.view = view
        let item1 = TodoItemViewModel(id: "1", textValue : "Washing Clothes", parentViewModel: self)
        let item2 = TodoItemViewModel(id: "2", textValue : "Buy Grocieries", parentViewModel: self)
        let item3 = TodoItemViewModel(id: "3", textValue : "Wash Car", parentViewModel: self)
        items.append(contentsOf: [item1, item2, item3])
    }
    var items : [TodoItemPresentable] = []
    
}

extension TodoViewModel : TodoViewDelegate {
    func onTodoDone(todoId: String) {
        print("Todo Item done with id = \(todoId)")
    }
    
    func onAddTodoItem() {
        print("New Value received..")
        
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

