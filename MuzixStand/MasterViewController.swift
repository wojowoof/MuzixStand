//
//  MasterViewController.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 3/14/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext?
    var myxtrabutton : UIBarButtonItem? = nil

    @IBOutlet weak var scrapsnpiles: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // myxtrabutton = UIBarButtonItem(title: String("Hi!"), style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        //myxtrabutton?.setTitle("My Button", for: UIControlState.normal)
        /*
        navigationItem.hidesBackButton = false
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItems = [editButtonItem, myxtrabutton] as? [UIBarButtonItem]
        navigationItem.prompt = String("foobar")

         Was:
         navigationItem.leftBarButtonItem = editButtonItem
         */

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        // navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            detailViewController?.mOC = self.managedObjectContext
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func scrapsnpiles(_ sender: Any) {
        switch scrapsnpiles.selectedSegmentIndex {
        case 0:
            print("Show scraps")
        case 1:
            print("Show piles")
        default:
            break
        }
        tableView.reloadData()
    }

    @objc
    func insertNewObject(_ sender: Any) {
        switch scrapsnpiles.selectedSegmentIndex {
        case 0:
            print("Add a scrap")
            self.insertNewScrap(sender)
        case 1:
            print("Add a pile")
            insertNewPile(sender)
        default:
            break
        }
    }

    func insertNewPile(_ sender: Any) {
        let ctx = self.fetchedResultsController.managedObjectContext
        let newPile = Pile(context: ctx)

        newPile.name = "New Pile"
        do {
            try ctx.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func insertNewScrap(_ sender: Any) {
        let context = self.fetchedResultsController.managedObjectContext
        let newScrap = Scrap(context: context)
             
        // If appropriate, configure the new managed object.
        newScrap.timestamp = Date()
        newScrap.name = "New Name"

        // Save the context.
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
            let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.mOC = managedObjectContext
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (0 == scrapsnpiles.selectedSegmentIndex) {
            return fetchedResultsController.sections?.count ?? 0
        } else {
            return fRC2.sections?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (0 == scrapsnpiles.selectedSegmentIndex) {
            return fetchedResultsController.sections![section].numberOfObjects
        } // else
        return fRC2.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"Cell", for:indexPath)
        if (0 == scrapsnpiles.selectedSegmentIndex) {
            let scrap = fetchedResultsController.object(at: indexPath)
            configureScrapCell(cell, withScrap: scrap)
        } else {
            let pile = fRC2.object(at: indexPath)
            configurePileCell(cell, withPile: pile)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var moc: NSManagedObjectContext? = nil
            if (0 == scrapsnpiles.selectedSegmentIndex) {
                moc = fetchedResultsController.managedObjectContext
            } else {
                moc = fRC2.managedObjectContext
            }
            moc!.delete(fetchedResultsController.object(at: indexPath))
                
            do {
                try moc!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func configureScrapCell(_ cell: UITableViewCell, withScrap scrap: Scrap) {
        //cell.textLabel!.text = event.timestamp!.description
        if scrap.name == nil {
            cell.textLabel!.text = "no name"
        } else {
            cell.textLabel!.text = "scrap " + scrap.name!.description
        }
    }

    func configurePileCell(_ cell: UITableViewCell, withPile pile: Pile) {

    }

    // MARK: - Fetched results controller
    var fRC2: NSFetchedResultsController<Pile> {
        let fR : NSFetchRequest<Pile> = Pile.fetchRequest()
        fR.fetchBatchSize = 20
        let sorter1 = NSSortDescriptor(key: "name", ascending: true)
        fR.sortDescriptors = [ sorter1 ]
        let anFRC = NSFetchedResultsController(fetchRequest: fR, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master2")
        anFRC.delegate = self
        _fRC2 = anFRC

        do {
            try _fRC2!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return _fRC2!
    }

    var _fRC2: NSFetchedResultsController<Pile>? = nil

    var fetchedResultsController: NSFetchedResultsController<Scrap> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<Scrap> = Scrap.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor1 = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "piles.name", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor2, sortDescriptor1]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: "piles.name", cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return _fetchedResultsController!
    }

    var _fetchedResultsController: NSFetchedResultsController<Scrap>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                if (0 == scrapsnpiles.selectedSegmentIndex) {
                    configureScrapCell(tableView.cellForRow(at: indexPath!)!, withScrap: anObject as! Scrap)
                } else {
                    configurePileCell(tableView.cellForRow(at: indexPath!)!, withPile: anObject as! Pile)
            }
            case .move:
                if (0 == scrapsnpiles.selectedSegmentIndex) {
                    configureScrapCell(tableView.cellForRow(at: indexPath!)!, withScrap: anObject as! Scrap)
                } else {
                    configurePileCell(tableView.cellForRow(at: indexPath!)!, withPile: anObject as! Pile)
                }
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */

}

