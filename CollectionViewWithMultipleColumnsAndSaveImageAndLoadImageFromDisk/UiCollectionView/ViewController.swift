//
//  ViewController.swift
//  UiCollectionView
//
//  Created by SujitAmin on 18/10/20.
//

import UIKit
import Foundation
import Network

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let MINIMUM_INTER_ITEM_SPACING : CGFloat = 8
    var data : Array = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        data = ["https://images.ctfassets.net/9l3tjzgyn9gr/photo-165358/1a59c7135903620130baa4c35517cfd6/165358-dogs.jpg",
            "https://images.ctfassets.net/9l3tjzgyn9gr/photo-165359/b4ce4d22b998255a9c08505aa6e82e52/165359-beaver.jpg",
            "https://images.ctfassets.net/9l3tjzgyn9gr/photo-165363/9f11b86f6a7c6d091136f408515231c2/165363-butterflies.jpg"
        ]
    }
    
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.imageViews.image = UIImage(named: "default")
        cell.imageViews.downloaded(from: data[indexPath.row % 3])
        return cell
        
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 2 * MINIMUM_INTER_ITEM_SPACING ) / 3
        return CGSize(width: size, height: size)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat( 2 * 8 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(MINIMUM_INTER_ITEM_SPACING)
    }
        
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
