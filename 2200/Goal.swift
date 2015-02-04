//
//  Goal.swift
//  2200
//
//  Created by Kiev Gama on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class Goal: NSObject, NSCoding {
    private var _weight: Int32 = 0;
    var weight: Int32 {
        get {
            return _weight;
        }
        set (newWeight) {
            _weight = newWeight
        }
    }
    

    required init(coder aDecoder: NSCoder) {
        _weight  = aDecoder.decodeIntForKey("weight")
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(_weight, forKey: "weight")
        
    }
}
    