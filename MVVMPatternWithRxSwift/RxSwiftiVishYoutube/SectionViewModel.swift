//
//  SectionViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 29/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionViewModel  {
    var header : String
    var items: [TodoItemViewModel]
}

extension SectionViewModel : AnimatableSectionModelType {
    typealias Item = TodoItemViewModel
    typealias Identity = String
    
    var identity: String {
        return header
    }
    init(original: SectionViewModel, items: [TodoItemViewModel]) {
        self = original
        self.items = items;
    }
}
