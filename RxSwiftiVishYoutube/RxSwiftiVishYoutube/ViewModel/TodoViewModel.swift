//
//  TodoViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol TodoItemViewDelegate {
    func onItemSelected()
}

protocol TodoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
}

struct TodoItemViewModel : TodoItemPresentable{
    var id: String? = "0"
    var textValue: String?
}

extension TodoItemViewModel : TodoItemViewDelegate {
    func onItemSelected() {
        
    }
}

protocol TodoViewDelegate {
    func onAddTodoItem()
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
        let item1 = TodoItemViewModel(id: "1", textValue : "Washing Clothes")
        let item2 = TodoItemViewModel(id: "2", textValue : "Buy Grocieries")
        let item3 = TodoItemViewModel(id: "3", textValue : "Wash Car")
        items.append(contentsOf: [item1, item2, item3])
    }
    var items : [TodoItemPresentable] = []
    
}

extension TodoViewModel : TodoViewDelegate {
    func onAddTodoItem() {
        print("New Value received..")
        
        guard let newValue = newTodoItem else {return}
        let newIndex = items.count + 1
        let item = TodoItemViewModel(id: "\(newIndex)", textValue: newValue)
        items.append(contentsOf: [item])
        self.newTodoItem = ""
        
        self.view?.insertTodoItem()
    }
}

