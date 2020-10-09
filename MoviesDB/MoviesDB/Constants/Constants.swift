//
//  Constants.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire

public struct Constants {
    struct URLS {
        public static let BASE_URL = "https://api.themoviedb.org/3"
        public static let GET_LIST = "/list/"
        public static let POSTER_PATH_URL = "http://image.tmdb.org/t/p/w185"
        public static let API_KEY_STRING : String = "api_key="
    }
    struct APIKEY {
        static let apiKey = "456a6a6b79806a567f5b60858de998a5"
    }
    struct Segues {
        static let showDetailSegue = "showDetail"
    }
    struct ImageNames {
        static let launchImage = "launch"
    }
    struct CellIdentifier {
        static let collectionViewCell = "collectionViewCell"
        static let tableViewCell = "detail"
    }
    struct CollectionViewCells {
        struct MoviesCollectionViewCell {
            static let inset: CGFloat = 0
            static let minimumLineSpacing: CGFloat = 0
            static let minimumInteritemSpacing: CGFloat = 0
            static let cellsPerRow = 2
        }
    }
}


