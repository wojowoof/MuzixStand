//
//  DetailViewController.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 3/14/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var pilesTable: UITableView!
    @IBOutlet weak var scrapName: UITextField!

    //var pilePickerData: [String] = [String]()

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                if nil != detail.name {
                    label.text = "name: " + detail.name!.description
                } else {
                    label.text = "no name"
                }
            } else {
                print("No label!")
            }
            if let sname = scrapName {
                sname.text = detail.name
            } else {
                print("No scrapName input?")
            }
            if let olabel = otherLabel {
                if nil == detail.piles {
                    olabel.text = "no piles"
                } else {
                    olabel.text = "more info" + detail.piles!.name!
                }
            } else {
                print("No otherLabel?")
            }

        } else {
            print("No detail!")
            otherLabel.text = "no item"
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        //pilePickerData = ["pile1", "pile2", "pile3"]
        pilesTable.delegate = self
        pilesTable.dataSource = self
        scrapName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Scrap? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        detailDescriptionLabel.text = textField.text
        detailItem?.name = textField.text
    }
    // TableView - for pile membership

    // CoreData functions as source for pile table
    var mOC: NSManagedObjectContext? = nil
    var fRC: NSFetchedResultsController<Pile> {
        if nil != _fRC {
            return _fRC!
        }

        let fR: NSFetchRequest<Pile> = Pile.fetchRequest()
        fR.fetchBatchSize = 40

        let sortDesc1 = NSSortDescriptor(key: "name", ascending: true)
        fR.sortDescriptors = [ sortDesc1 ]
        let aFRC = NSFetchedResultsController(fetchRequest: fR, managedObjectContext: self.mOC!, sectionNameKeyPath: nil, cacheName: "Piles")
        aFRC.delegate = self
        _fRC = aFRC
        do {
            try _fRC?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Fetch error: \(nserror), \(nserror.userInfo)")
        }
        return _fRC!
    }
    var _fRC: NSFetchedResultsController<Pile>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pilesTable.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            pilesTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            pilesTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return;
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let thePile: Pile = anObject as! Pile
        switch type {
        case .insert:
            pilesTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            pilesTable.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configCell(pilesTable.cellForRow(at: indexPath!)!, withText:thePile.name)
        case .move:
            configCell(pilesTable.cellForRow(at: indexPath!)!, withText:thePile.name)
            pilesTable.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pilesTable.endUpdates()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This occurs because, on startup, the detailView is instantiated before a selection is made; so there's nothing to display, tho more importantly: no segue has occurred, so no mOC setup has happened.
        // Added set of mOC to master's viewDidLoad(), so this should now be unnecessary, though it's still strange to bring up a detail view to start the app.
        /* if nil == mOC {
            return 0
        } */
        let sInfo = fRC.sections![section]
        return sInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let thePile = fRC.object(at: indexPath)
        configCell(cell, withText: thePile.name)
        return cell
    }

    private func configCell(_ cell: UITableViewCell, withText txt: String?) {
        if (nil == txt) {
            cell.textLabel!.text = "NO NAME"
        } else{
            cell.textLabel!.text = txt;
        }
    }


    // Pickerview -- OLD CODE, @@@ deleteme @@@
    // Pickerview Delegate
    /*
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("pickerview: selected \(row) aka \(pilePickerData[row])")
    }

    // Pickerview Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Picker: \(pilePickerData.count) rows")
        return pilePickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pilePickerData[row]
    }
     */
    // EOPickerView code


}

