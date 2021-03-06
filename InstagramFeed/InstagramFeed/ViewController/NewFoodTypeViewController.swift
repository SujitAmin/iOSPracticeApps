//
//  NewFoodTypeViewController.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MBProgressHUD

class NewFoodTypeViewController: UIViewController {
    @IBOutlet weak var titleTextField : UITextField!
    @IBOutlet weak var mainImageButton : UIButton!
    @IBOutlet weak var firstImageButton : UIButton!
    @IBOutlet weak var secondImageButton : UIButton!
    
    private var currentButton : UIButton?
    var firestore : FirestoreService!
    let storage = StorageService.shared
    
    
    //this is an example how to pass data using closures.
    var onDataAvailable : ((_ data : String) -> ())?
    private lazy var pickerController : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerController.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.onDataAvailable?("how are you?")
    }
    
    @IBAction func dismissKeyBoard() {
        titleTextField.endEditing(true)
    }
    
    @IBAction func setPhoto(_ sender : UIButton) {
        currentButton = sender
        present(pickerController, animated: true)
    }
    
    @IBAction func saveFoodType(_ sender : UIButton) {
        guard let title = titleTextField.text,
            let mainImage = mainImageButton.backgroundImage(for: .normal),
            let firstImage = firstImageButton.backgroundImage(for: .normal),
            let secondImage = secondImageButton.backgroundImage(for: .normal)
        else { return }
        showIndicator(withTitle: "Loading...", and: "Fetching Images...")
        storage.bulkUpload([mainImage, firstImage, secondImage]) { [weak self] (urlPaths) in
            let foodType = FoodType(mainImagePath: urlPaths[0] , title: title, otherImagePaths: [urlPaths[1], urlPaths[2]])
            self?.firestore.save(foodType, completion: { (result) in
                print(result)
                
                self?.hideIndicator()
                self?.navigationController?.popViewController(animated: true)
            })
        }
    }
}
extension NewFoodTypeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        //get image from picker view, original image
        guard let image = info[.originalImage] as? UIImage else { return }
        //set it to our current button
        currentButton?.setBackgroundImage(image, for: .normal)
    }
}
