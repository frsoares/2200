//
//  ProgressView.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

var progress: CGFloat = 8

class ProgressView: UIView {
    
//    var propertyChangedListener : (CGFloat, CGFloat) -> Void = {
//        println("The value of progress has changed from \($0) to \($1)")
//    }
//    
//    var progress: CGFloat = 0 {
//        didSet{
//            ProgressView.setNeedsDisplay()
//            propertyChangedListener(oldValue, ProgressView.progress)
//        }
//    }
    
    let rectPosition = 362 + (-progress * 36) 
    let polyPosition1 = 340 + (-progress * 36)
    let polyPosition2 = 362 + (-progress * 36)
    
    
    override func drawRect(rect: CGRect) {

        //// Color Declarations
        let color = UIColor(red: 0.565, green: 0.937, blue: 0.478, alpha: 1.000)

  
        // Polygon Drawing
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(200, polyPosition1))
        polygonPath.addLineToPoint(CGPointMake(400, polyPosition2))
        polygonPath.addLineToPoint(CGPointMake(0, polyPosition2))
        polygonPath.closePath()
        color.setFill()
        polygonPath.fill()


        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, rectPosition, 400, 362))
        color.setFill()
        rectanglePath.fill()
        
        
    }
    

}
