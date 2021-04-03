//
//  HttpUtility.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//
import Foundation
import UIKit
import Alamofire

class HttpUtility {
    static func getApiData<T: Codable>(requestUrl : URL, decodingType: T.Type ,completionHandler : ((T?, Error?) -> Void)? ) {
        AF.request(requestUrl, method: .get).validate().responseJSON { (response) in
            switch (response.result) {
            case .success:
                if let data = response.data {
                    do {
                        let result = try JSONDecoder().decode(decodingType, from: data)
                        DispatchQueue.main.async {
                            completionHandler?(result, nil);
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completionHandler?(nil, error);
                        }
                        
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler?(nil, response.error);
                    }
                }
                break;
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler?(nil, error)
                }
                break;
            }
        }
    }
    
    static func postApiData<T: Codable>(requestUrl: URL, requestBody : Parameters, resultType : T.Type, completionHandler: @escaping (_ result : T? , _ error : Error?) -> Void) {
        AF.request(requestUrl,method: .post , parameters: requestBody, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let json = try JSONDecoder().decode(resultType, from: data)
                        DispatchQueue.main.async {
                            completionHandler(json, nil);
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completionHandler(nil, error);
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(nil, response.error);
                    }
                }
                break;
            case .failure(let error):
                DispatchQueue.main.async {
                    completionHandler(nil, error);
                }
                break;
            }
        }
    }
}

