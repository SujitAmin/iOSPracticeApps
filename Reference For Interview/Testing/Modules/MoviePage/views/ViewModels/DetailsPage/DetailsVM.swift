//
//  DetailsVM.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import Foundation

class DetailsVM {
    var model : MovieDetailsModel?
    init(model: MovieDetailsModel) {
        self.model = model;
    }
    
    func getPosterPath() -> String {
        return model?.posterPath ?? "";
    }
    
    func getOverview() -> String {
        return model?.overview ?? "";
    }
    
    func getTitle() -> String {
        return model?.title ?? "";
    }
}
