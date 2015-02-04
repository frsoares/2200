//
//  ProgressView.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

var progress: CGFloat = 1

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
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
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
        
        /// animation
        
//        func moveProgress(view: ProgressView){
//            var toPoint: CGPoint = CGPointMake(0.0, 320.0)
//            var fromPoint : CGPoint = CGPointMake(0.0, 0.0)
//            
//            var movement = CABasicAnimation(keyPath: "movement")
//            movement.additive = true
//            movement.fromValue =  NSValue(CGPoint: fromPoint)
//            movement.toValue =  NSValue(CGPoint: toPoint)
//            movement.duration = 0.3
//            
//            view.layer.addAnimation(movement, forKey: "move")
//        }
        
        
        
    }
    

}
