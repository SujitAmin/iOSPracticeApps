//
//  ApiUrlConstants.swift
//  Testing
//
//  Created by SujitAmin on 02/04/21.
//

import Foundation

class ApiUrlConstants {
    static let baseUrl = "https://api.themoviedb.org/3/movie/";
    static let popularUrl = baseUrl +  "popular?api_key=" + ApiKeys.apiKey + "&language=en-US";
    static let imageUrl = "https://image.tmdb.org/t/p/w500/";
    static let detailsUrl = baseUrl;
}
