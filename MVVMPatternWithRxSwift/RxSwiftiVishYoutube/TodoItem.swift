//
//  TodoItem.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 23/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    @objc dynamic var todoId : Int = 0
    @objc dynamic var todoValue : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var createdAt : Date? = Date()
    @objc dynamic var updatedAt : Date?
    @objc dynamic var deletedAt : Date?
    @objc dynamic var todoType : String = "Personal"
    
    override class func primaryKey() -> String? {
        return "todoId"
    }
}
