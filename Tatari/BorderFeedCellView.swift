//
//  BorderFeedCellView.swift
//  Tatari
//
//  Created by Déborah Mesquita on 13/11/15.
//  Copyright © 2015 Caio Araújo. All rights reserved.
//

import UIKit

class BorderFeedCellView: UIView {

    override func drawRect(rect: CGRect){
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 4.0)
        CGContextSetStrokeColorWithColor(context,
            UIColor.blueColor().CGColor)
        let rectangle = CGRectMake(0,0,200,80)
        CGContextAddRect(context, rectangle)
        CGContextStrokePath(context)
    }

}
