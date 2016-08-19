//
//  ProgressView.swift
//  2200
//
//  Created by Eduardo Borges Pinto Osório on 2/4/15.
//  Copyright (c) 2015 Eduardo Borges Pinto Osório. All rights reserved.
//

import UIKit



class ProgressView: UIView {
    

    var progress : CGFloat = CGFloat(0.0) {
      didSet{
        self.setNeedsDisplay()
      }
    }
  
    
    
    override func draw(_ rect: CGRect) {

      
        let rectPosition = 362 + -(self.progress * 36)
        let polyPosition1 = 340 + -(self.progress * 36)
        let polyPosition2 = 362 + -(self.progress * 36)
      
        //// Color Declarations
        let color = UIColor(red: 0.565, green: 0.937, blue: 0.478, alpha: 1.000)

  
        // Polygon Drawing
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 190, y: polyPosition1))
        polygonPath.addLine(to: CGPoint(x: 380, y: polyPosition2))
        polygonPath.addLine(to: CGPoint(x: 0, y: polyPosition2))
        polygonPath.close()
        color.setFill()
        polygonPath.fill()


        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: rectPosition, width: 380, height: 362))
        color.setFill()
        rectanglePath.fill()
        
        
    }
    

}
