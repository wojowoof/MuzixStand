//
//  dataHelper.swift
//  MuzixStand
//
//  Created by Jack Woychowski on 4/19/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit
import CoreData

public class dataHelper: NSObject {
    let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func seedData(){
        self.seedPiles()
    }

    func seedPiles() {
        let pstrings = [
            "Finger Exercises",
            "Everybody Wants to Rule The World",
            ] as [String]
        for pname in pstrings {
            let newPile = Pile(context: context)
            newPile.name = pname
        }
        do {
            try context.save()
        } catch _ {

        }
    }

    func dumpPiles() {
        let allPiles = getPiles() as [Pile]
        for pile in allPiles {
            print("Pile: \(String(describing: pile.name))");
        }
    }

    func getPiles() -> [Pile] {
        let pileFR : NSFetchRequest<Pile> = Pile.fetchRequest()
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        pileFR.sortDescriptors = [sortDesc]
        let allPiles = try! context.fetch(pileFR)

        return allPiles
    }
}
