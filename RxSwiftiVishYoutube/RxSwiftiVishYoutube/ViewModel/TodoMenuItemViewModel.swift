//
//  TodoMenuItemViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 17/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//MARK:- Protocols
protocol TodoMenuItemViewPresentable {
    var title : String? { get set }
    var backColor : String? { get }
}

protocol TodoMenuItemViewDelegate  {
    func onMenuItemSelected()
}

//MARK:- Class TodoMenuItemViewModel
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
