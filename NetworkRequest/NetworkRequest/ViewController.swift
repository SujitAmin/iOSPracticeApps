//
//  ViewController.swift
//  NetworkRequest
//
//  Created by Admin on 29/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let BASE_URL = "https://yocket.in/users/login.json?_uniqueDeviceKey="
        let uniqueId = "80764624-CF0A-4D45-957D-9029A82B054E"
        let parameters:Parameters = [ "email": "masters123@testaccount.com",
        "password":"1234" ]
        let wholeUrl = BASE_URL + uniqueId
        print("My Url :")
        print(wholeUrl)
        guard let url = URL(string: wholeUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) {(data,response,error) in
            if let response = response {
                print("My response")
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print("Error")
                    print(error)
                }
            }
            
        }.resume()
        
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 284)
        label.textAlignment = NSTextAlignment.center
        label.text = "I'm a test label"
        self.view.addSubview(label)
    }
    func alam() {
        let BASE_URL = "https://yocket.in/users/login.json?_uniqueDeviceKey="
        let uniqueId = "80764624-CF0A-4D45-957D-9029A82B054E"
        let parameters:Parameters = [ "email": "masters123@testaccount.com",
        "password":"1234" ]
        let wholeUrl = BASE_URL + uniqueId
        print("My Url :")
        print(wholeUrl)
        AF.request(wholeUrl, method: .post, parameters: parameters, encoding: URLEncoding.default).response { response in
            debugPrint(response)
        }
        //Alamofire.request("https://yocket.in/users/login.json?_uniqueDeviceKey=\(uniqueDeviceID)", method: .post, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { (response) in
    }

}
extension UILabel {
  func set(html: String) {
    if let htmlData = html.data(using: .unicode) {
      do {
        self.attributedText = try NSAttributedString(data: htmlData,
                                                     options: [.documentType: NSAttributedString.DocumentType.html],
                                                     documentAttributes: nil)
      } catch let e as NSError {
        print("Couldn't parse \(html): \(e.localizedDescription)")
      }
    }
  }
}
