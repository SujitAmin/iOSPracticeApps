//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import SVProgressHUD

class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextfield.isSecureTextEntry = true
        let array = [6, 2,3,9,4,2,1]
        print(array.map({"\($0)"}))
    }

    @IBAction func registerPressed(_ sender: AnyObject) {
        SVProgressHUD.show()

        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (user, error) in
            if error != nil {
                print(error)
            } else {
                print("Registration Successful")
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
            
        }
    } 
    
    
}


