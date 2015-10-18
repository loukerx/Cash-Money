//
//  ScrollViewShadows.swift
//  Cash Money
//
//  Created by Yin Hua on 18/10/2015.
//  Copyright © 2015 Yin Hua. All rights reserved.
//

import UIKit

class ScrollViewShadows: UIScrollView {

 
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let myShadowOffset = CGSizeMake (0,1)
        CGContextSaveGState(context)
        
        CGContextSetShadowWithColor(context, myShadowOffset, 5, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)

        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, self.frame.size.width, 0)
        CGContextStrokePath(context)
        CGContextRestoreGState(context)
        
    }


}
