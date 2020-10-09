//
//  ViewController.swift
//  UiButtonWithCounter
//
//  Created by Admin on 08/08/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textView: UITextField!
    var counter = 0
    var counterAmount = 0
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = String(counterAmount)
        textView.delegate = self
        
    }
    @objc func start() {
        if counterAmount > 0 {
            counterAmount = counterAmount - 1
            label.text = String(counterAmount)
        } else {
            timer.invalidate()
            let alert = UIAlertController(title: "Timer Count Down Done", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert,animated : true, completion : nil)
            
            print("Invalidated")
        }
        
    }

    @IBAction func buttonaction(_ sender: Any) {
        counterAmount = Int(textView.text!) ?? 100
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(start), userInfo: nil, repeats: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
    
    
}

