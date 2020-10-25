//
//  ApiService.swift
//  RxSwiftiVishYoutube
//
//  Created by SujitAmin on 25/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiServiceProtocol {
   associatedtype ResponseData
   func fetchAllTodos(completion: @escaping (ResponseData) -> Void)
}

class ApiService : ApiServiceProtocol{
    static let sharedInstance : ApiService = ApiService()
    
    private init() {}
    
    typealias ResponseData = Data
    
    func fetchAllTodos(completion: @escaping (Data) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/15471230-bf35-42b5-9fbc-551df4227d54")
        AF.request(url!).responseJSON { (response) in
            print(response.response?.statusCode)
            print(response.request)
            print(response.data)
            
            completion(response.data!)
        }
        
    }
    
}
