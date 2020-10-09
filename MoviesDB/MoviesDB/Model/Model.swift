//
//  Model.swift
//  MoviesDB
//
//  Created by Admin on 12/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

// MARK: - Model
public struct Model: Codable {
    public let createdBy, modelDescription: String?
    public let favoriteCount: Int?
    public let id: String?
    public let items: [Item]?
    public let itemCount: Int?
    public let name, posterPath: String?

    enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case modelDescription = "description"
        case favoriteCount = "favorite_count"
        case id, items
        case itemCount = "item_count"
        case name
        case posterPath = "poster_path"
    }

    public init(createdBy: String?, modelDescription: String?, favoriteCount: Int?, id: String?, items: [Item]?, itemCount: Int?, name: String?, posterPath: String?) {
        self.createdBy = createdBy
        self.modelDescription = modelDescription
        self.favoriteCount = favoriteCount
        self.id = id
        self.items = items
        self.itemCount = itemCount
        self.name = name
        self.posterPath = posterPath
    }
}
