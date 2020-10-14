//
//  FirestoreService.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class  FirestoreService {
    private init() {}
    static let shared = FirestoreService()
   
    private let database = Firestore.firestore()
    private lazy var foodTypesReference = database.collection("foodTypes")
    
    func save(_ foodType: FoodType, completion: @escaping (Result<Bool, NSError>) -> Void) {
        foodTypesReference.addDocument(data: ["mainImagePath" : foodType.mainImagePath,
                                              "title": foodType.title,
                                              "otherImagePaths": foodType.otherImagePaths.enumerated()
        ]) { (error) in
            if let unwrappedError = error {
                completion(.failure(unwrappedError as NSError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func listen(completion: @escaping ([FoodType]) -> Void) {
        foodTypesReference.addSnapshotListener { (snapshot, error) in
            guard let unwrappedSnapshot = snapshot else { return }
            let documents = unwrappedSnapshot.documents
            
            var foodTypes = [FoodType]()
            for document in documents {
                let documentData = document.data()
                guard let mainImagePath = documentData["mainImagePath"] as? String,
                      let title = document["title"] as? String,
                      let otherImagePathsDict = documentData["otherImagePaths"] as? [Int: String]  else {
                    continue
                }
                
                let otherImagePaths = otherImagePathsDict.map { $0.value }
                let foodType = FoodType(mainImagePath: mainImagePath, title: title, otherImagePaths: otherImagePaths)
                
                foodTypes.append(foodType)
            }
            
        }
    }
}
