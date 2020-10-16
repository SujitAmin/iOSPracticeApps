//
//  FoodType.swift
//  InstagramFeed
//
//  Created by SujitAmin on 12/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

public struct FoodType : Decodable {
    let mainImagePath : String
    let title : String
    let otherImagePaths : [String]
    var allImagePaths : [String] { return [mainImagePath] + otherImagePaths }
}
