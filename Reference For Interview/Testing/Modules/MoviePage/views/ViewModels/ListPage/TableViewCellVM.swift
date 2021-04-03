//
//  TableViewCellVM.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import Foundation

class TableViewCellVM {
    var model : Result;
    init(model : Result) {
        self.model = model;
    }
    
    func getOriginalTitle() -> String {
        return model.originalTitle ?? "";
    }
    func getPosterPath() -> String {
        return model.posterPath ?? "";
    }
    
    func getVoteAverage() -> Double {
        return (model.voteAverage ?? 0)/2;
    }
    
    func getId() -> Int {
        return model.id ?? 0;
    }
}
