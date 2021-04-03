//
//  PassportListVC.swift
//  CDRelationships
//
//  Created by CodeCat15 on 7/8/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import UIKit

class PassportListVC: UIViewController {

    var passport : [Passport]?
    private let passportManager: PassportManager = PassportManager()

    @IBOutlet weak var tblPassportList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Passport List"
        viewWillSetUp()
        self.hideKeyboardWhenTappedAround();
    }

    func viewWillSetUp() {
        passport = passportManager.getAllPassports()
        if(passport != nil && passport?.count != 0) {
            self.tblPassportList.reloadData()
        }
    }
    
}
