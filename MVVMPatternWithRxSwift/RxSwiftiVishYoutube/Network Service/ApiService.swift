//
//  ApiService.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 25/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa

protocol ApiServiceProtocol {
   associatedtype ResponseData
   func fetchAllTodos(/*completion: @escaping (ResponseData) -> Void*/) -> (Observable<JSON>)
}

class ApiService : ApiServiceProtocol{
    static let sharedInstance : ApiService = ApiService()
    
    private init() {}
    
    typealias ResponseData = Data
    
    func fetchAllTodos(/*completion: @escaping (Data) -> Void*/) -> (Observable<JSON>) {
        let url = URL(string: "https://run.mocky.io/v3/15471230-bf35-42b5-9fbc-551df4227d54")
        
        return Observable.create ({ (observer) -> Disposable in
            let request = AF.request(url!).responseJSON { (response) in
                switch (response.result) {
                case .success(let value):
                    
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        let responseJson = JSON(value)
                        observer.onNext(responseJson)
                        observer.onCompleted()
                    } else {
                        print("Error");
                        observer.onError(NSError(domain: "Yocket", code: -1, userInfo: nil))
                    }
                    break;
                case .failure(let error):
                    print("Something went wrong!")
                    observer.onError(NSError(domain: "Yocket", code: -1, userInfo: nil))
                    break;
                }
            }
            return Disposables.create {
                request.cancel()
            }
        })
        
        
    }
    
}
