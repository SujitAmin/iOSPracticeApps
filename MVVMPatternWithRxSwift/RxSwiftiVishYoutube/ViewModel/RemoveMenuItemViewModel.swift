//
//  RemoveMenuItemViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 17/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//MARK:- RemoveMenuItemViewModel
class RemoveMenuItemViewModel: TodoMenuItemViewModel {
    override func onMenuItemSelected() {
        parent?.onRemoveSelected()
    }
}
