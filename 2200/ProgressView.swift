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

        var mask = CAShapeLayer()
        mask.frame = self.layer.bounds
        
        let width = self.layer.frame.size.width
        let height = self.layer.frame.size.height
        
        var path = CGPathCreateMutable()
        
        CGPathMoveToPoint(path, nil, 30, 0)
        CGPathAddLineToPoint(path, nil, width, 0)
        CGPathAddLineToPoint(path, nil, width, height)
        CGPathAddLineToPoint(path, nil, 0, height)
        CGPathAddLineToPoint(path, nil, 30, 0)
        
        mask.path = path
}

}
