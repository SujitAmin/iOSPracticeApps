//
//  EmployeeProvider.swift
//  FCDemo
//
//  Created by CodeCat15 on 8/15/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation
import CoreData


class EmployeeProvider {
    private weak var fetchedResultControllerDelegate: NSFetchedResultsControllerDelegate?

    init(With fetchedResultControllerDelegate: NSFetchedResultsControllerDelegate) {
        self.fetchedResultControllerDelegate = fetchedResultControllerDelegate
    }
    
    lazy var fetchedResultController: NSFetchedResultsController<CDEmployee> =
        {
            let fetchRequest: NSFetchRequest<CDEmployee> = CDEmployee.fetchRequest()
            fetchRequest.fetchBatchSize = 20
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistentStorage.shared.context, sectionNameKeyPath: nil, cacheName: nil)
            controller.delegate = fetchedResultControllerDelegate
            do{
                 try controller.performFetch()
            } catch{
                debugPrint(error)
            }

            return controller
    }()

}
