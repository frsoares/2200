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
        if let data = UserDefaults.standard.object(forKey: "goalData") as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as? Goal
        }
        return nil;
    }
    
    
    func saveGoal(_ newGoal: Goal) {
        let data = NSKeyedArchiver.archivedData(withRootObject: newGoal)
        UserDefaults.standard.set(data, forKey: "goaldata")
    }
    
    
}
