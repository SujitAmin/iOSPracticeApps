//
//  ViewController.swift
//  CachingWithCoreData
//
//  Created by SujitAmin on 17/02/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //createEmployee();
        fetchEmployee()
    }

    func createEmployee() {
        let employee = Employee(context: PersistentStorage.shared.context);
        employee.name = "Sujit";
        PersistentStorage.shared.saveContext();
    }
    
    func fetchEmployee() {
        do {
            guard let result = try PersistentStorage.shared.context.fetch(Employee.fetchRequest()) as? [Employee] else { return }
            
            result.forEach({debugPrint($0.name)});
        } catch let error {
            print(error);
        }
        
    }
}

