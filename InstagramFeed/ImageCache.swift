//
//  ImageCache.swift
//  InstagramFeed
//
//  Created by SujitAmin on 15/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ImageCache : NSCache<NSString, AnyObject> {
    func save(_ image: UIImage) {
        
    }
    func getImage(named imageName : String, completion: @escaping (UIImage?) -> Void) {
        if let image = object(forKey: imageName as NSString) as? UIImage {
            completion(image)
        } else {
            let url = URL(string: imageName)!
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    setObject(image, forKey: imageName as NSString)
                    completion(image)
                }
                
                
            } catch {
                print(error)
            }
        }
    }
}
