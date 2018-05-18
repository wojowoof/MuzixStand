//
//  PileDetailViewController.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 5/17/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

class PileDetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pileNameLabel: UITextView!
    @IBOutlet weak var pileTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PDVC: viewDidLoad")
        configView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var pile : Pile? {
        didSet {
            configView()
        }
    }
    
    func configView() {
        if let thepile = pile {
            if nil != thepile.name {
                if let pileentry = pileTextField {
                    print("Set pile name: \(String(describing: thepile.name))")
                    pileentry.text = thepile.name
                } else {
                    print("No pile entry?")
                }
                if let pilelabel = pileNameLabel {
                    pilelabel.text = thepile.name
                }
            }
        } else {
            print("No pile!")
        }
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pileTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //detailDescriptionLabel.text = textField.text
        var oldname = pile?.name
        // label.text = textField.text
        pile?.name = pileTextField.text
        do {
            try pile?.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            //titleLabel.text = oldname
            pile?.name = oldname
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
