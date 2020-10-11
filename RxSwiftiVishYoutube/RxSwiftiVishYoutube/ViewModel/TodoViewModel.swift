//
//  TodoViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol TodoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
}

struct TodoItemViewModel : TodoItemPresentable{
    var id: String? = "0"
    
    var textValue: String?
    
    
}

protocol TodoItemViewDelegate {
    func onTodoItemAdded() -> ()
}

struct TodoViewModel {
    
    var newTodoItem: String?
    var items : [TodoItemPresentable] = []
    
    init() {
        let item1 = TodoItemViewModel(id: "1", textValue : "Washing Clothes")
        let item2 = TodoItemViewModel(id: "2", textValue : "Buy Grocieries")
        let item3 = TodoItemViewModel(id: "3", textValue : "Wash Car")
        items.append(contentsOf: [item1, item2, item3])
    }
    
}

extension TodoViewModel : TodoItemViewDelegate {
    func onTodoItemAdded() {
        
    }
}
