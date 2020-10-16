//
//  StorageService.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageService {
    private init() {}
    static let shared = StorageService()
    
    private let storage = Storage.storage()
    
    //THIS IS FOLDER.
    private lazy var imagesReference = storage.reference().child("images")
    
    
    func upload(_ image: UIImage, completion : @escaping (String) -> Void) {
        /*
         UUIDs are generally used for identifying information that needs to be unique within a system or network thereof. Their uniqueness and low probability in being repeated makes them useful for being associative keys in databases and identifiers for physical hardware within an organization.
         */
        let imageRef = imagesReference.child("images/\(UUID().uuidString).jpg")
        //we compress the data before sending....
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
    
    func bulkUpload(_ images: [UIImage], completion: @escaping([String]) -> Void) {
        var imagePaths = [String]()
        var counter = 0
        
        for image in images {
            upload(image) { (urlPath) in
                imagePaths.append(urlPath)
                counter += 1
                if counter == images.count {
                    completion(imagePaths)
                }
            }
        }
    }
}
