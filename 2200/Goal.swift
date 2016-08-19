//
//  Goal.swift
//  2200
//
//  Created by Kiev Gama on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class Goal: NSObject, NSCoding {
    
    
    fileprivate var _weight: Int = 0;
    fileprivate var _weeks: Int = 0;
    
    var weight: Int {
        get {
            return _weight;
        }
        set (newWeight) {
            _weight = newWeight
        }
    }
    
    var weeks: Int {
        get {
            return _weeks;
        }
        set (newWeeks) {
            _weeks = newWeeks
        }
    }
    
    
    override init () {
            _weight = 65
    }
    
    required init(coder aDecoder: NSCoder) {
        _weight  = aDecoder.decodeInteger(forKey: "weight")
        _weeks  = aDecoder.decodeInteger(forKey: "weeks")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_weight, forKey: "weight")
        aCoder.encode(_weeks, forKey: "weeks")
    }
    
}
    
