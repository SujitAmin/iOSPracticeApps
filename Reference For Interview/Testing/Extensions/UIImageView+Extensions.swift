//
//  UIImageView.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .default).async { [weak self] in
            if let img = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage{
                DispatchQueue.main.async {
                    self?.image = img
                }
            }
            else{
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
    
    func curvedImage(radius: CGFloat) {
        self.layer.cornerRadius = radius;
        self.clipsToBounds = true;
        self.layer.masksToBounds = true;
    }
}
