//
//  ViewController.swift
//  GermanyFlag
//
//  Created by Admin on 18/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //constraint priorities
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        flagUkraine()
    }
    
    func flagUkraine() {
        topView.backgroundColor = UIColor(red: 0 , green: 0, blue: 1, alpha: 1)
        middleView.removeFromSuperview()
    }


}

