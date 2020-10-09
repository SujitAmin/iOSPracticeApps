//
//  MovieListViewModel.swift
//  MoviesDB
//
//  Created by Admin on 26/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

public struct MovieItemViewModel {
   public let posterPath: String?
   public let popularity: Double?
   public let id: Int?
   public let title: String?
   public let overview: String?

   init(movieItem : Item?) {
       self.posterPath = movieItem?.posterPath;
       self.popularity = movieItem?.popularity;
       self.id = movieItem?.id;
       self.title = movieItem?.title
       self.overview = movieItem?.overview
   }
}
