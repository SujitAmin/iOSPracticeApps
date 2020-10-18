//
//  ViewController.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import Kingfisher

class ViewController: UIViewController {
    
    private var pageNumber = 1;
    private var isDataLoading = false
    private var overView : String?
    private var posterImageURL : String?

    //Model
    private var model : Model?
    private var itemViewModel : [MovieItemViewModel]?
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView.isPrefetchingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CardView", bundle: nil), forCellWithReuseIdentifier: Constants.CellIdentifier.collectionViewCell)
        loadData()
    }
    private func loadData() {
        let url = Constants.URLS.BASE_URL + Constants.URLS.GET_LIST + "\(pageNumber)" + "?" + Constants.URLS.API_KEY_STRING + Constants.APIKEY.apiKey
        print(url)
        AF.request(url, method: .get).responseData {
            (response) in
            guard let data = response.data else { return }
            DispatchQueue.main.async {
                self.model = try? newJSONDecoder().decode(Model.self, from: data)
                let myItem = self.model?.items;
                self.itemViewModel = myItem?.map({ return  MovieItemViewModel(movieItem: $0)});
                self.collectionView.reloadData()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isDataLoading {
            isDataLoading = true;
            self.pageNumber = self.pageNumber + 1;
            let temp = Constants.URLS.BASE_URL  + Constants.URLS.GET_LIST
            let temp2 = "\(pageNumber)" + "?" + Constants.URLS.API_KEY_STRING + Constants.APIKEY.apiKey
            let url = temp + temp2
            AF.request(url, method: .get).responseData {
                (response) in
                print(response.request?.allHTTPHeaderFields)
                print(response.request?.urlRequest)
                guard let data = response.data else { return }
                DispatchQueue.main.async {
                    self.model = try? newJSONDecoder().decode(Model.self, from: data)
                    let myItem = self.model?.items;
                    self.itemViewModel?.append(contentsOf: myItem?.map({ return  MovieItemViewModel(movieItem: $0)}) ?? [])
                    self.isDataLoading = false;
                    guard let count =  myItem?.count else { return }
                    var array = [IndexPath]()
                    print("Value : \(count)")
                    
                    //reload a part of collectionview
                    //this method only reloads the part of UICollectionView
                    if count > 0 {
                        for i in 0...(count - 1) {
                            array.append(IndexPath(row: i, section: 0))
                        }
                        self.collectionView.reloadItems(at: array)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.overView = overView;
            destination.posterImageURL = posterImageURL
        }
    }
    
}
extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemViewModel?.count ?? 0;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifier.collectionViewCell, for: indexPath) as? CardView
        let urlPosterPath = Constants.URLS.POSTER_PATH_URL + (itemViewModel?[indexPath.row].posterPath ?? "")
        let imageResource : ImageResource = ImageResource(downloadURL: URL(string: urlPosterPath)!, cacheKey: itemViewModel?[indexPath.row].posterPath)
        cell?.movieImage.kf.setImage(with: imageResource, placeholder: UIImage(named: Constants.ImageNames.launchImage))
        cell?.movieImage.contentMode = .scaleToFill
        return cell ?? UICollectionViewCell();
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        overView = itemViewModel?[indexPath.row].overview
        posterImageURL = Constants.URLS.POSTER_PATH_URL + (itemViewModel?[indexPath.row].posterPath)!
        performSegue(withIdentifier: Constants.Segues.showDetailSegue, sender: self)
    }
}
extension ViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size:CGFloat = (collectionView.frame.size.width - 8) / 2.0
        return CGSize(width: size, height: 300)
    }
    //between 2 columns
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    //between two rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

