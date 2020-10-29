//
//  TodoItemViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 17/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

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
    var type: String?
    var textValue: String?
    weak var parent: TodoViewDelegate?
    var menuItems: [TodoMenuItemViewPresentable]? = []
    
    
    init(id: String, textValue : String, type : String ,parentViewModel : TodoViewDelegate) {
        self.id = id
        self.textValue = textValue
        self.parent = parentViewModel
        self.type = type
        
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

extension TodoItemViewModel : IdentifiableType, Equatable {
    typealias Identity = String
    var identity: String {
        return id!
    }
    
    static func == (lhs: TodoItemViewModel, rhs: TodoItemViewModel) -> Bool {
        return lhs.id! == rhs.id!
    }
}
