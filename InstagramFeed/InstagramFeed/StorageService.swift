//
//  StorageService.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import FirebaseStorage

class  StorageService {
    private init() {}
    static let shared = StorageService()
    
    private let storage = Storage.storage()
    private lazy var imagesReference = storage.reference().child("images")
    
    
    func upload(_ image: UIImage, completion : @escaping (String) -> Void) {
        let imageRef = imagesReference.child("images/\(Date().timeIntervalSince1970).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let unwrappedError = error {
                print(unwrappedError)
            } else {
                imageRef.downloadURL { (url, error) in
                    if let unwrappedDownloadError = error {
                        print(unwrappedDownloadError)
                    } else if let url = url {
                        completion(url.absoluteString)
                    }
                }
            }
            
        }
    }
}
