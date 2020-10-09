//
//  ViewController.swift
//  CameraWithUploadOfFile
//
//  Created by Admin on 28/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {

    let shapeLayer = CAShapeLayer()
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0 %"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
             let myPickerController = UIImagePickerController()
             myPickerController.delegate = self
             myPickerController.allowsEditing = true
             myPickerController.sourceType = .camera
             self.present(myPickerController, animated: true, completion: nil)
        }
        else {
             let actionController: UIAlertController = UIAlertController(title: "Camera is not available",message: "", preferredStyle: .alert)
             let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void  in }
             actionController.addAction(cancelAction)
             self.present(actionController, animated: true, completion: nil)
        }
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
        view.backgroundColor = .black
        // let's start by drawing a circle somehow
        // create my track layer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc private func handleTap() {
       print("Attempting to animate stroke")
       beginDownloadingFile()
    }
    fileprivate func beginDownloadingFile() {
        shapeLayer.strokeEnd = 0
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        
        downloadTask.resume()
    }
    
    //for upload task
    fileprivate func uploadTask() {
        var request = try URLRequest(url: URL(string: urlString)!)
        request.setValue("Bearer adsjhia9e", forHTTPHeaderField: "Authorization")
        request.setValue("video/*", forHTTPHeaderField: "Content-Type")
        request.setValue("278", forHTTPHeaderField: "Content-Length")
        request.timeoutInterval = 60.0
        
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "mov")
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let uploadTask = session.uploadTask(with: request, fromFile: videoURL!) { (data, response, Error) in
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.allHeaderFields)
                
                if httpResponse.statusCode != 200 {
                    return
                } else  {
                    if let url = httpResponse.allHeaderFields["Location"] as? String {
                        
                    }
                }
            }
        }
        uploadTask.resume()
    }
}
extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
    }
}
extension ViewController : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished Downloading.....")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage * 100))%"
            self.shapeLayer.strokeEnd = percentage
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        //upload progress bar is updated here....
    }
}

