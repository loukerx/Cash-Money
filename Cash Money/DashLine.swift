//
//  DashLine.swift
//  Cash Money
//
//  Created by Yin Hua on 17/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import UIKit

class DashLine: UIView {


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 10.0)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        let dashArray:[CGFloat] = [5,5]
        CGContextSetLineDash(context, 10, dashArray, 2)
        
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, self.frame.size.width, 0)
        CGContextStrokePath(context)
        
    }
    
}
