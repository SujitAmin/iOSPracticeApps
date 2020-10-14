//
//  NewFoodTypeViewController.swift
//  InstagramFeed
//
//  Created by SujitAmin on 13/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NewFoodTypeViewController: UIViewController {
    @IBOutlet weak var titleTextField : UITextField!
    @IBOutlet weak var mainImageButton : UIButton!
    @IBOutlet weak var firstImageButton : UIButton!
    @IBOutlet weak var secondImageButton : UIButton!
    
    private var currentButton : UIButton?
    var firestore : FirestoreService!
    let storage = StorageService.shared
    
    private lazy var pickerController : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
    }
    
    @IBAction func dismissKeyBoard() {
        titleTextField.endEditing(true)
    }
    
    @IBAction func setPhoto(_ sender : UIButton) {
        currentButton = sender
        present(pickerController, animated: true)
    }
    @IBAction func saveFoodType(_ sender : UIButton) {
        
    }
}
extension NewFoodTypeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        currentButton?.setBackgroundImage(image, for: .normal)
    }
}
