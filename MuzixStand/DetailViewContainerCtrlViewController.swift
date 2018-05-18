//
//  DetailViewContainerCtrlViewController.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 5/10/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit

class DetailViewContainerCtrl: UIViewController, UISplitViewControllerDelegate {

    var pileDetail : PileDetailViewController? = nil
    var scrapDetail: ScrapDetailViewController? = nil
    var topController: UIViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DVCCVC: viewDidLoad")
        self.pileDetail = self.storyboard?.instantiateViewController(withIdentifier: "pileController") as? PileDetailViewController
        self.scrapDetail = self.storyboard?.instantiateViewController(withIdentifier: "scrapController") as? ScrapDetailViewController
        
        self.addChildViewController(pileDetail!)
        self.addChildViewController(scrapDetail!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPileViewWith(pile: Pile) {
        pileDetail?.pile = pile
        self.showChildViewController(childCtrl:pileDetail!)
    }
    
    func showScrapViewWith(scrap: Scrap) {
        scrapDetail?.scrap = scrap
        self.showChildViewController(childCtrl: scrapDetail!)
    }

    func showChildViewController(childCtrl: UIViewController) {
        if (topController != childCtrl) {
            print("Show \(childCtrl)")
            childCtrl.view.frame = view.frame
            view.addSubview(childCtrl.view)
            childCtrl.didMove(toParentViewController: self)
            topController = childCtrl
        } else {
            print("Already showing \(childCtrl)")
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
