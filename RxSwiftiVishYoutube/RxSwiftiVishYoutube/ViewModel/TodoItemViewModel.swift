//
//  TodoItemViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 17/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//MARK:- Protocols
protocol TodoItemViewDelegate : class {
    func onItemSelected()
    func onRemoveSelected()
    func onDoneSelected()
}

protocol TodoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
    var isDone : Bool? { get set }
    var menuItems : [TodoMenuItemViewPresentable]? { get }
}

//MARK:- Class TodoItemViewModel
class TodoItemViewModel : TodoItemPresentable{
    var isDone: Bool? = false
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
        doneMenuItem.title = isDone! ? "Undone" : "Done"
        doneMenuItem.backColor = "0000ff"
        menuItems?.append(contentsOf: [removeMenuItem, doneMenuItem])
    }
}

//MARK:- Extension
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
