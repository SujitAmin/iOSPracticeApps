//
//  CoreDataTableViewController.swift
//  RSSFeedReader
//
//  Created by Admin on 05/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
protocol CoreDataTableViewControllerDelegate : class {
    func request(urlString : URL?)
}
class CoreDataTableViewController: UITableViewController {

    var people: [NSManagedObject] = []
    weak var delegate : CoreDataTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
             return
         }
        var managedContext : NSManagedObjectContext?
        if #available(iOS 13.0, *) {
            managedContext =
                appDelegate.persistentContainer.viewContext
        }
        
         //2
         let fetchRequest =
           NSFetchRequest<NSManagedObject>(entityName: "Feed")
         
         //3
         do {
            people = try managedContext!.fetch(fetchRequest)
         } catch let error as NSError {
           print("Could not fetch. \(error), \(error.userInfo)")
         }
        
        let alertController = UIAlertController(title: "Add Feed", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Feed Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let feedName = alertController.textFields![0] as UITextField
            let feedURL = alertController.textFields![1] as UITextField
            
            if feedURL.text != "" && feedName.text != "" {
                if #available(iOS 13.0, *) {
                    self.save(name: feedName.text!, url: feedURL.text! )
                } 
                self.tableView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Feed URL"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
      return people.count
    }

    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
                   -> UITableViewCell {

      let person = people[indexPath.row]
      let cell =
        tableView.dequeueReusableCell(withIdentifier: "Cell",
                                      for: indexPath)
      cell.textLabel?.text =
        person.value(forKeyPath: "name") as? String
      return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = people[indexPath.row]
        let urlString = feed.value(forKey: "url")
        guard let url = URL(string: urlString! as! String) else {return}
        print("CoreData : \(url)")
        delegate!.request(urlString:  url)
        navigationController?.popViewController(animated: true)
    }
    @available(iOS 13.0, *)
    func save(name: String, url : String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Feed",
                                   in: managedContext)!
      
      let feed = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      feed.setValue(name, forKeyPath: "name")
      feed.setValue(url, forKey: "url")
      
      // 4
      do {
        try managedContext.save()
        people.append(feed)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
}
