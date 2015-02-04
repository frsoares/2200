//
//  GoalStore.swift
//  2200
//
//  Created by Kiev Gama on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class GoalStore: NSObject {
    
    
    func getGoal() -> Goal? {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("goalData") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Goal
        }
        return nil;
    }
    
    
    func saveGoal(newGoal: Goal) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(newGoal)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "goaldata")
    }
    
    
}
