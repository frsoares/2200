//
//  ProgressView.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit



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

    var progress : CGFloat = CGFloat(0.0) {
      didSet{
        self.setNeedsDisplay()
      }
    }
  
    
    
    override func drawRect(rect: CGRect) {

      
        var rectPosition = 362 + -(self.progress * 36)
        var polyPosition1 = 340 + -(self.progress * 36)
        var polyPosition2 = 362 + -(self.progress * 36)
      
        //// Color Declarations
        let color = UIColor(red: 0.565, green: 0.937, blue: 0.478, alpha: 1.000)

  
        // Polygon Drawing
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(190, polyPosition1))
        polygonPath.addLineToPoint(CGPointMake(380, polyPosition2))
        polygonPath.addLineToPoint(CGPointMake(0, polyPosition2))
        polygonPath.closePath()
        color.setFill()
        polygonPath.fill()


        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, rectPosition, 380, 362))
        color.setFill()
        rectanglePath.fill()
        
        
    }
    

}
