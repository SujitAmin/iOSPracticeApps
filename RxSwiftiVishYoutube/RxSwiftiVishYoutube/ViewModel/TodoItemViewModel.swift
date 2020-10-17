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

//MARK:- Class TodoItemViewModel
class TodoItemViewModel : TodoItemPresentable{
    var isDone: Bool? = false
    var id: String? = "0"
    var textValue: String?
    weak var parent: TodoViewDelegate?
    var menuItems: [TodoMenuItemViewPresentable]? = []
    
    
    init(id: String, textValue : String, parentViewModel : TodoViewDelegate) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        
        let removeMenuItem = RemoveMenuItemViewModel(parentViewModel: self)
        removeMenuItem.title = "Remove"
        removeMenuItem.backColor = Constants.RED_COLOR  
        
        let doneMenuItem = DoneMenuItemViewModel(parentViewModel: self)
        doneMenuItem.title = isDone! ? "Undone" : "Done"
        doneMenuItem.backColor = Constants.BLUE_COLOR
        
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
