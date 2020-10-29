//
//  TodoViewModel.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import RxSwift
import RealmSwift

//MARK:- Protocols
protocol TodoViewDelegate : class {
    func onAddTodoItem()
    func onTodoDelete(todoId: String)
    func onTodoDone(todoId: String)
}

protocol TodoViewPresentable {
    var newTodoValue : String? { get }
    var searchValue : Variable<String> { get }
}

protocol TodoItemPresentable {
    var id : String? { get }
    var textValue : String? { get }
    var isDone : Bool? { get set }
    var menuItems : [TodoMenuItemViewPresentable]? { get }
}

//MARK:- Class TodoViewModel
class TodoViewModel : TodoViewPresentable {
    var searchValue: Variable<String> = Variable("")
    var filteredItems: Variable<[TodoItemPresentable]> = Variable([])
    
    var newTodoValue: String?
    var newTodoItem : String?
    //weak var view : TodoView?
    var items : Variable<[TodoItemPresentable]> = Variable([])
    var database : Database?
    var notificationToken : NotificationToken? = nil
    
    lazy var searchValueObservable : Observable<String> = self.searchValue.asObservable()
    lazy var itemsObservable : Observable<[TodoItemPresentable]> = self.items.asObservable()
    lazy var filteredItemsObservable : Observable<[TodoItemPresentable]> = self.filteredItems.asObservable()
    
    let disposeBag = DisposeBag()
    
    init(/*view : TodoView*/) {
        database = Database.singleton
        fetchTodos()
        handleRealmNotifications()
        
        searchValueObservable.subscribe(onNext: { [self] (value) in
            self.itemsObservable.map( { $0.filter ({
                if value.isEmpty { return true }
                return ($0.textValue?.lowercased().contains(value.lowercased()))!
            })
            }).bind(to: filteredItems)
        }).disposed(by: disposeBag)
    }
    
    fileprivate func handleRealmNotifications() {
        let todoItemResults = database?.fetch()
        notificationToken = todoItemResults?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch (changes) {
            case .initial:
                todoItemResults?.forEach({ (todoItemEntity) in
                    let todoItemEntity = todoItemEntity
                    let itemIndex = todoItemEntity.todoId
                    let newValue = todoItemEntity.todoValue
                    let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newValue, parentViewModel:  self!)
                    self?.items.value.append(newItem)
                })
                break
            case .update(_, let deletions, let insertions,let modifications):
                insertions.forEach { (index) in
                    let todoItemEntity = todoItemResults![index]
                    let itemIndex = todoItemEntity.todoId
                    let newValue = todoItemEntity.todoValue
                    let newItem = TodoItemViewModel(id: "\(itemIndex)", textValue: newValue, parentViewModel:  self!)
                    self?.items.value.append(newItem)
                }
                
                modifications.forEach { (index) in
                    let todoItemEntity = todoItemResults![index]
                    
                    
                    guard let index = self?.items.value.firstIndex(where:  {Int($0.id!) == todoItemEntity.todoId}) else { return }
                    
                    if todoItemEntity.deletedAt != nil {
                        self?.items.value.remove(at: index)
                        self?.database?.delete(primaryKey: todoItemEntity.todoId)
                        return
                    } else {
                        var todoItemVm = self?.items.value[index]
                        
                        todoItemVm?.isDone = todoItemEntity.isDone
                        if var doneMenuItem = todoItemVm?.menuItems?.filter({ (todoMenuItem) -> Bool in
                            todoMenuItem is DoneMenuItemViewModel
                        }).first {
                            doneMenuItem.title = (todoItemVm?.isDone!)! ? "Undone" : "Done"
                        }
                    }
                    
                }
                break
            case .error(let error):
                break
            default:
                break
            }
            self?.items.value.sort(by: {
                if !($0.isDone!) && !($1.isDone!) {
                    return $0.id! < $1.id!
                }
                if $0.isDone! && $1.isDone! {
                    return $0.id! < $1.id!
                }
                return !($0.isDone!) && $1.isDone!
            })
        })
        //        let item1 = TodoItemViewModel(id: "1", textValue : "Washing Clothes", parentViewModel: self)
        //        let item2 = TodoItemViewModel(id: "2", textValue : "Buy Grocieries", parentViewModel: self)
        //        let item3 = TodoItemViewModel(id: "3", textValue : "Wash Car", parentViewModel: self)
        //        items.value.append(contentsOf: [item1, item2, item3])
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    fileprivate func fetchTodos() {
        //self.view = view
//        ApiService.sharedInstance.fetchAllTodos { (data) in
//            print(data)
//            if let todosDict = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                if let todosArray = todosDict["todos"] as? NSArray {
//                    todosArray.forEach { (todoItemDict) in
//                        if let itemDict = todoItemDict as? [String : Any] {
//                            //print(itemDict["id"])
//                            //print(itemDict["value"])
//                            if let _ = itemDict["id"], let value = itemDict["value"] as? String{
//                                self.database?.createOrUpdate(todoItemValue: value)
//                            }
//                        }
//                    }
//                }
//            }
//        }
        let todosObservable = ApiService.sharedInstance.fetchAllTodos()
        todosObservable.subscribe { (jsonResponse) in
            if let todosArray = jsonResponse["todos"].array {
                todosArray.forEach { (todoItemDict) in
                    if let itemDict = todoItemDict.dictionary {
                        if let id = itemDict["id"]?.int, let value = itemDict["value"]?.string {
                            self.database?.createOrUpdate(todoItemValue: value)
                        }
                    }
                }
            }
            print(jsonResponse)
        } onError: { (error) in
            print(error)
        } onCompleted: {
            print("Request completed")
        } onDisposed: {
            print("Disposed...")
        }

    }
}

//MARK:- Extension
extension TodoViewModel : TodoViewDelegate {
    func onAddTodoItem() {
        guard let newValue = newTodoItem else {return}
        //        let newIndex = items.value.count + 1
        //        let item = TodoItemViewModel(id: "\(newIndex)", textValue: newValue, parentViewModel: self)
        //        items.value.append(contentsOf: [item])
        //        self.newTodoItem = ""
        //self.view?.insertTodoItem()
        database?.createOrUpdate(todoItemValue: newValue)
        self.newTodoItem = ""
    }
    func onTodoDelete(todoId: String) {
        //        guard let index = self.items.value.firstIndex(where:  {$0.id! == todoId}) else { return }
        //        self.items.value.remove(at: index)
        database?.softDelete(primaryKey: Int(todoId)!)
        // self.view?.removeTodoItem(index: index)
        
    }
    
    func onTodoDone(todoId: String) {
        //guard let index = self.items.value.firstIndex(where:  {$0.id! == todoId}) else { return }
        
        //        var todoItem = self.items.value[index]
        //        todoItem.isDone = !(todoItem.isDone)!
        //        if var doneMenuItem = todoItem.menuItems?.filter({ (todoMenuItem) -> Bool in
        //            todoMenuItem is DoneMenuItemViewModel
        //        }).first {
        //            doneMenuItem.title = todoItem.isDone! ? "Undone" : "Done"
        //        }
        
        //        self.items.value.sort(by: {
        //            if !($0.isDone!) && !($1.isDone!) {
        //                return $0.id! < $1.id!
        //            }
        //            if $0.isDone! && $1.isDone! {
        //                return $0.id! < $1.id!
        //            }
        //            return !($0.isDone!) && $1.isDone!
        //        })
        //self.view?.reloadItems()
        database?.isDone(primaryKey: Int(todoId)!)
    }
}

