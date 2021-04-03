//
//  MovieDetailViewController.swift
//  Testing
//
//  Created by SujitAmin on 03/04/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var movieId : Int?
    //var detailsModel : MovieDetailsModel?;
    var viewModel : DetailsVM?
    var numberOfSections = 2;
    var numberOfRowsInSection = 1;
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        fetchData();
    }
    
    func prepareView() {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UINib(nibName: TableViewCellName.imageViewCell, bundle: nil), forCellReuseIdentifier: TableViewCellName.imageViewCell);
        self.tableView.register(UINib(nibName: TableViewCellName.textViewCell, bundle: nil), forCellReuseIdentifier: TableViewCellName.textViewCell);
        self.tableView.separatorStyle = .none;
        self.tableView.backgroundColor = Theme.defaultBackgroundColor;
    }
    
    
    func fetchData() {
        HttpUtility.getApiData(requestUrl: URL(string: ApiUrlConstants.detailsUrl + "\(movieId!)?api_key=\(ApiKeys.apiKey)")!, decodingType: MovieDetailsModel.self, completionHandler: {[weak self] (response, error) in
            if(error != nil) {
                debugPrint(error!);
                return
            }
            guard let self = self else {return}
            if let response = response {
                self.viewModel = DetailsVM(model: response);
            }
            //self.detailsModel = response;
            self.tableView.reloadData();
        });
    }

}
