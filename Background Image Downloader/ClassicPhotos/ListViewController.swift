import UIKit

let dataSourceURL = URL(string:"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist")!

class ListViewController: UITableViewController {
    var photos: [PhotoRecord] = []
    let pendingOperations = PendingOperations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Classic Photos"
        fetchPhotoDetails()
    }
    
    func fetchPhotoDetails() {
        let request = URLRequest(url: dataSourceURL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let task = URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            let alertController =  self.alert()
            
            if let data = data {
                do {
                    let datasourceDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String: String]
                    for (name, value) in datasourceDictionary {
                        let url = URL(string: value)
                        if let url = url {
                            let photoRecord = PhotoRecord(name: name, url: url)
                            self.photos.append(photoRecord)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            if error != nil {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
    
    fileprivate func alert() -> UIAlertController {
        let alertController = UIAlertController(title: "Oops!", message: "There was an error fetching photo details.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        return alertController
    }
    // MARK: - operation management
    func suspendAllOperations() {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func resumeAllOperations() {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    func loadImagesForOnscreenCells() {
        // Start with an array containing index paths of all the currently visible rows in the table view.
        if let pathsArray = tableView.indexPathsForVisibleRows {
            //    Construct a set of all pending operations by combining all the downloads in progress and all the filters in progress.
            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            
            //    Construct a set of all index paths with operations to be cancelled. Start with all operations, and then remove the index paths of the visible rows. This will leave the set of operations involving off-screen rows.
            var toBeCancelled = allPendingOperations
            let visiblePaths = Set(pathsArray)
            toBeCancelled.subtract(visiblePaths)
            
            //    Construct a set of index paths that need their operations started. Start with index paths all visible rows, and then remove the ones where operations are already pending.
            var toBeStarted = visiblePaths
            toBeStarted.subtract(allPendingOperations)
            
            //    Loop through those to be cancelled, cancel them, and remove their reference from PendingOperations.
            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }
            //    Loop through those to be started, and call startOperations(for:at:) for each.
            for indexPath in toBeStarted {
                let recordToProcess = photos[indexPath.row]
                startOperations(for: recordToProcess, at: indexPath)
            }
        }
    }
    
    func startOperations(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        switch (photoRecord.state) {
        case .new:
            startDownload(for: photoRecord, at: indexPath)
        default:
       //     NSLog("do nothing")
            print("")
        }
    }





    func startDownload(for photoRecord: PhotoRecord, at indexPath: IndexPath) {
        //    First, check for the particular indexPath to see if there is already an operation in downloadsInProgress for it. If so, ignore this request.
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        //    If not, create an instance of ImageDownloader by using the designated initializer.
        let downloader = ImageDownloader(photoRecord)
        //    Add a completion block which will be executed when the operation is completed. This is a great place to let the rest of your app know that an operation has finished. It’s important to note that the completion block is executed even if the operation is cancelled, so you must check this property before doing anything. You also have no guarantee of which thread the completion block is called on, so you need to use GCD to trigger a reload of the table view on the main thread.
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        //    Add the operation to downloadsInProgress to help keep track of things.
        pendingOperations.downloadsInProgress[indexPath] = downloader
        //    Add the operation to the download queue. This is how you actually get these operations to start running — the queue takes care of the scheduling for you once you’ve added the operation.
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
}

extension ListViewController {
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        let photoDetails = photos[indexPath.row]
        cell.textLabel?.text = photoDetails.name
        cell.imageView?.image = photoDetails.image
        
        switch (photoDetails.state) {
        case .failed:
            indicator.stopAnimating()
            cell.textLabel?.text = "Failed to load"
        case .downloaded:
            indicator.stopAnimating()
        case .new:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: photoDetails, at: indexPath)
            }
        }
        
        return cell
    }
}
//scrollview delegate methods
extension ListViewController {
    // MARK: - scrollview delegate methods
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        suspendAllOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            resumeAllOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        resumeAllOperations()
    }
}
