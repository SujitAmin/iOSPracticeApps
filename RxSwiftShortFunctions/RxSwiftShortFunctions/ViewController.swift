//
//  ViewController.swift
//  RxSwiftShortFunctions
//
//  Created by SujitAmin on 11/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observableSequence()
        subjects()
    }
    
    func subjects() {
        let subject = PublishSubject<String>()
        subject.subscribe {
            print($0)
        }
        
        
        subject.on(.next("Hello"))
        subject.onCompleted()
        subject.onNext("World")
        
        let newSubscription = subject.subscribe{
            print("New Subscription : \($0)")
        }
        newSubscription.dispose()
        subject.onNext("Still here?")
        
        exampleOf(description: "BehaviorSubject") {
            let subject = BehaviorSubject(value: "a")
            _ = subject.subscribe(onNext: { (value) in
                print("\(#line) \(value)")
            })
            subject.onNext("b")
            
            _ = subject.subscribe(onNext: { (value) in
                print("\(#line) \(value)")
            })
        }
        
        exampleOf(description: "ReplaySubject") {
            let subject = ReplaySubject<Int>.create(bufferSize: 3)
            subject.onNext(1)
            subject.onNext(2)
            subject.onNext(3)
            subject.onNext(4)
            
            subject.subscribe(onNext: { (value) in
                print(value)
            })
        }
        
        exampleOf(description: "BehaviorRelay") {
            let disposeBag = DisposeBag()
            let behaviorRelay = BehaviorRelay(value: "A")
            behaviorRelay.asObservable().subscribe(onNext: { (value) in
                print(value)
                }, onDisposed: {
                  
                })
        }
    }
    
    func observableSequence()  {
       exampleOf(description: "just") {
            let observable = Observable.just(1)
            observable.subscribe { ( event: Event<Int> ) in
                print(event)
            }
        }
        
        exampleOf(description: "of") {
            let observable = Observable.of(1,2,3)
            observable.subscribe {
                print($0)
            }
        }
        let array : PublishSubject<[Int]> = PublishSubject<[Int]>()
        
        exampleOf(description: "toObservable"){
            array.asObservable().subscribe {
                print($0)
            }
        }
    }

}

