//
//  Database.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 23/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    static let singleton = Database()
    
    private init() {}
    
    func createOrUpdate(todoItemValue : String) {
        let realm = try! Realm()
        
        var todoId : Int? = 1
        
        let isEmpty = realm.objects(TodoItem.self).filter({ $0.todoValue.lowercased() == todoItemValue.lowercased()}).isEmpty
        
        if !isEmpty {
            return
        }
        
        if let lastEntity = realm.objects(TodoItem.self).last {
            todoId = lastEntity.todoId + 1
        }
        
        let todoItemEntity = TodoItem()
        todoItemEntity.todoId = todoId!
        todoItemEntity.todoValue = todoItemValue
        
        try! realm.write {
            realm.add(todoItemEntity)
        }
    }
    
    func softDelete(primaryKey: Int) -> Void {
        let realm = try! Realm()
        
        if let todoItemEntity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                todoItemEntity.deletedAt = Date()
            }
        }
    }
    
    func fetch() -> (Results<TodoItem>) {
        let realm = try! Realm()
        
        let todoItemResults = realm.objects(TodoItem.self)
        return todoItemResults
    }
    
    func delete(primaryKey: Int) -> Void {
        let realm = try! Realm()
        
        if let todoItementity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write{
                return realm.delete(todoItementity)
            }
        }
    }
    
    func isDone(primaryKey: Int) -> Void {
        let realm = try! Realm()
        
        if let todoItemEntity = realm.object(ofType: TodoItem.self, forPrimaryKey: primaryKey) {
            try! realm.write {
                todoItemEntity.isDone = !todoItemEntity.isDone
            }
        }
    }
}
