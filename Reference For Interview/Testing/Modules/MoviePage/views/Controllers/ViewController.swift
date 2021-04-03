import Foundation
import UIKit

class ViewController : UIViewController {
 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var noOfSections = 1;
    var pageCount = 1;
    var maxPageCount = 0;
    var fetchingData = false;
    //var results : [Result]?;
    var viewModel : ListViewModel?
    var selectedIndex = 0;
    override func viewDidLoad() {
        super.viewDidLoad();
        prepareView();
        fetchData();
    }
    
    func prepareView() {
        navigationItem.title = "Movie"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.register(UINib(nibName: TableViewCellName.cardView, bundle: nil), forCellReuseIdentifier: TableViewCellName.cardView);
        self.tableView.separatorStyle = .none;
        self.activityIndicator.isHidden = true;
    }
    
    func fetchData() {
        if(CheckNetwork.isConnectedToNetwork()) {
            HttpUtility.getApiData(requestUrl: URL(string: ApiUrlConstants.popularUrl + "&page=\(pageCount)")!, decodingType: MovieModel.self) { (response, error) in
                if let response = response {
                    self.viewModel = ListViewModel(model: response);
                }
                self.maxPageCount = self.viewModel?.getMaxPageCount() ?? 0;
                self.tableView.reloadData();
            }
        } else {
            let alert = UIAlertController(title: StringConstants.internetNotConnectedTitle, message: StringConstants.internetNotConnectedMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: StringConstants.okButton, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if((self.tableView.contentOffset.y > 0) && (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height) && pageCount <= maxPageCount && fetchingData == false) {
            fetchingData = true;
            pageCount = pageCount + 1;
            self.activityIndicator.isHidden = false
            self.activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating();
            HttpUtility.getApiData(requestUrl: URL(string: ApiUrlConstants.popularUrl + "&page=\(pageCount)")!, decodingType: MovieModel.self, completionHandler: ({ [weak self] (response, error) in
                guard let self = self else {return}
                if(error != nil) {
                    print(error!);
                    return;
                }
                if let response = response {
                    self.viewModel?.addPaginatedData(newModel: response)
                }
                self.activityIndicator.isHidden = true;
                self.activityIndicator.stopAnimating();
                self.fetchingData = false;
                self.tableView.reloadData();
            }));
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! MovieDetailViewController
        viewController.movieId = viewModel?.getSelectedIndex(selectedIndex: selectedIndex);
    }
}
