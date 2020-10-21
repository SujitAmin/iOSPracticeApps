//
//  ViewController.swift
//  CompletionHandlerAndClosures
//
//  Created by SujitAmin on 19/10/20.
//

import UIKit

class ViewController: UIViewController {
    let url = "https://www.metaweather.com/api/location/search/?query=london"
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func networkRequest(_ sender: UIButton) {
        guard let url = URL(string: url ) else {return}
        exceuteNetworkRequest(url: url) { [weak self] (data, error) in
            DispatchQueue.main.async {
                do {
                    guard let data = data else { return }
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if let cityWeatherDict = jsonResponse?.first{
                        self?.textView.text = cityWeatherDict.debugDescription
                    }
                } catch {
                    print(error)
                }
                
            }
        }
    }
    
    private func exceuteNetworkRequest(url : URL , completionHandler : ( (Data?, Error?) -> Void)? ) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                    if (jsonResponse?.first) != nil{
                        completionHandler?(data, nil)
                    }
                } catch {
                    print(error.localizedDescription)
                    completionHandler?(nil, error)
                }
            } else {
                completionHandler?(nil, error)
            }
        }
        task.resume()
    }
}

