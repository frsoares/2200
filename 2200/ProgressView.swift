//
//  ProgressView.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {

        //// Color Declarations
        let color = UIColor(red: 0.565, green: 0.937, blue: 0.478, alpha: 1.000)
        
        //// Initial Bezier Drawing
//        var bezierPath = UIBezierPath()
//        bezierPath.moveToPoint(CGPointMake(0, 360))
//        bezierPath.addLineToPoint(CGPointMake(400, 360))
//        bezierPath.addLineToPoint(CGPointMake(400, 350.46))
//        bezierPath.addLineToPoint(CGPointMake(200, 327))
//        bezierPath.addLineToPoint(CGPointMake(0, 350.46))
//        bezierPath.addLineToPoint(CGPointMake(0, 360))
//        bezierPath.addLineToPoint(CGPointMake(0, 360))
//        bezierPath.closePath()
//        color.setFill()
//        bezierPath.fill()
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 255, 400, 105))
        color.setFill()
        rectanglePath.fill()
        
        //// Polygon Drawing
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(200, 230))
        polygonPath.addLineToPoint(CGPointMake(400, 255))
        polygonPath.addLineToPoint(CGPointMake(0, 255))
        polygonPath.closePath()
        color.setFill()
        polygonPath.fill()
    
        let progressAnimation = CABasicAnimation()
        
    }

}
