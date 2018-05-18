//
//  ScrapDetailViewController.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 5/10/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class ScrapDetailViewController: UIViewController, UITableViewDelegate,
    // UITableViewDataSource,
    // NSFetchedResultsControllerDelegate,
    UITextFieldDelegate {

    //var _scrap : Scrap?
    
    @IBOutlet weak var scrapName: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SDVC: viewDidLoad")
        configView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configView() {
        if let thescrap = scrap {
            if nil != thescrap.name {
                print("Set name to \(String(describing: thescrap.name))")
                if let scrapentry = scrapName {
                    scrapentry.text = thescrap.name
                } else {
                    print("No name entry?")
                }
                if let theTitle = titleLabel {
                    theTitle.text = thescrap.name
                }
            }
        } else {
            print("Scrapless?")
        }
    }

    var scrap : Scrap? {
        didSet {
            configView()
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //detailDescriptionLabel.text = textField.text
        var oldname = scrap?.name
        titleLabel.text = textField.text
        scrap?.name = textField.text
        do {
            try scrap?.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            titleLabel.text = oldname
            scrap?.name = oldname
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
