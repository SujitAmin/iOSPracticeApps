//
//  ListViewModel.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import Foundation

class ListViewModel {
    var model : MovieModel?
    var listViewModel : [TableViewCellVM]?
    init(model : MovieModel) {
        self.model = model;
        if let list = model.results {
            listViewModel = list.map(TableViewCellVM.init);
        }
    }
    
    func getItemAtIndexPath(row: Int) -> TableViewCellVM {
        return listViewModel![row];
    }
    
    func getCount() -> Int {
        return listViewModel?.count ?? 0;
    }
    
    func getMaxPageCount() -> Int {
        return model?.totalPages ?? 0;
    }
    
    func getSelectedIndex(selectedIndex : Int) -> Int {
        return listViewModel![selectedIndex].getId();
    }
    
    func addPaginatedData(newModel : MovieModel) {
        guard let results = newModel.results else {return};
        self.model?.results! += results;
        self.listViewModel = self.model?.results!.map(TableViewCellVM.init);
    }
}
