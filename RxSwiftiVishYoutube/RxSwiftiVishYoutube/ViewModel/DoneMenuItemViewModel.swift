//
//  DoneMenuItemViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 17/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

//MARK:- DoneMenuItemViewModel
class  DoneMenuItemViewModel : TodoMenuItemViewModel {
    override func onMenuItemSelected() {
        print("Done item selected")
        parent?.onDoneSelected()
    }
}
