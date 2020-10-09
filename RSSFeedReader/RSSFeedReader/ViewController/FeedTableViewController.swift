//
//  FeedTableViewController.swift
//  RSSFeedReader
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MWFeedParser
import KINWebBrowser
import SideMenu
import Kingfisher
import Foundation

class FeedTableViewController: UITableViewController {
    
    var feedItems = [MWFeedItem]()
    var coreDataTableViewController : CoreDataTableViewController?
    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        coreDataTableViewController?.delegate = self
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(onMenuClicked))
        self.navigationItem.rightBarButtonItem = camera
        request(urlString:  nil)
    }
    @objc func onMenuClicked() {
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? CoreDataTableViewController
        destination?.delegate = self
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for : indexPath) as? FeedTableViewCell
        
        cell?.feedImage.image = UIImage(named: "placeholder")
        
        let item = feedItems[indexPath.row] as? MWFeedItem
        cell?.author.text = item?.author
        cell?.subTitle.text = item?.title
        
        //image ad karne ke liye....
        if item?.content != nil {
            let htmlContent = item!.content as NSString
            var imageSource = ""
            
            let rangeOfString = NSMakeRange(0, htmlContent.length)
            let regex = try? NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [] )
            if htmlContent.length > 0 {
                let match = regex?.firstMatch(in: htmlContent as String, options: [], range: rangeOfString)
                
                if match != nil {
                    let imageUrl = htmlContent.substring(with: (match?.range(at: 2))!)
                    //if NSString(string: imageUrl.lowercased().range(of:"feedburner")?.startIndex == NSNotFound) {
                        imageSource = imageUrl
                    //}
                }
            }
            if imageSource != "" {
                let imageResource = ImageResource(downloadURL: URL(string: imageSource)!)
                cell?.feedImage.kf.setImage(with: imageResource)
            }
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feedItems[indexPath.row] as MWFeedItem
        
        //let webBrowser = WKWebView()
        guard let url = URL(string: item.link) else {return}
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var vc = WebViewViewController()
        if #available(iOS 13.0, *) {
            print("Goes here")
            vc = storyBoard.instantiateViewController(identifier: "WebViewViewController") as! WebViewViewController
        }
        vc.url = url
        present(vc, animated: true, completion: nil)
    }
}
extension FeedTableViewController : MWFeedParserDelegate {
    func feedParserDidStart(_ parser: MWFeedParser!) {
        feedItems = [MWFeedItem]()
    }
    func feedParserDidFinish(_ parser: MWFeedParser!) {
        self.tableView.reloadData()
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedInfo info: MWFeedInfo!) {
        self.title = info.title
    }
    func feedParser(_ parser: MWFeedParser!, didParseFeedItem item: MWFeedItem!) {
        feedItems.append(item)
    }
}
extension FeedTableViewController : CoreDataTableViewControllerDelegate {
    func request(urlString: URL?) {
        if urlString == nil {
            guard let url = URL(string: "https://rss.nytimes.com/services/xml/rss/nyt/Technology.xml" ) else {return}
            let feedParser = MWFeedParser(feedURL: url)
            feedParser?.delegate = self
            feedParser?.parse()
        } else {
            let feedParser = MWFeedParser(feedURL: urlString)
            feedParser?.delegate = self
            feedParser?.parse()
        }
        tableView.reloadData()
    }
    
    
}
