//
//  Item.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - Item
public struct Item: Codable {
    public let posterPath: String?
    public let popularity: Double?
    public let voteCount: Int?
    public let video: Bool?
    public let mediaType: String?
    public let id: Int?
    public let adult: Bool?
    public let backdropPath, originalLanguage, originalTitle: String?
    public let genreIDS: [Int]?
    public let title: String?
    public let voteAverage: Double?
    public let overview: String?

    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case mediaType = "media_type"
        case id, adult
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case title
        case voteAverage = "vote_average"
        case overview
    }

    public init(posterPath: String?, popularity: Double?, voteCount: Int?, video: Bool?, mediaType: String?, id: Int?, adult: Bool?, backdropPath: String?, originalLanguage: String?, originalTitle: String?, genreIDS: [Int]?, title: String?, voteAverage: Double?, overview: String?) {
        self.posterPath = posterPath
        self.popularity = popularity
        self.voteCount = voteCount
        self.video = video
        self.mediaType = mediaType
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.genreIDS = genreIDS
        self.title = title
        self.voteAverage = voteAverage
        self.overview = overview
    }
}
