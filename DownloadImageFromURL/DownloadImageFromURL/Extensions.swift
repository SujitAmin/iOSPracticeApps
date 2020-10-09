//
//  Extensions.swift
//  DownloadImageFromURL
//
//  Created by Admin on 28/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if let img = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage{
                print("Cached...")
                DispatchQueue.main.async {
                    self?.image = img
                }
            }
            else{
                print("Not Cached...")
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageCache.setObject(image, forKey: url.absoluteString as NSString)
                            self?.image = image
                        }
                    }
                }
            }
            
            
        }
    }
}
