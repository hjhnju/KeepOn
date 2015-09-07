//
//  JTCalendarCustomDayView.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

@IBDesignable
class EmptyCircleView: UIView {
    
    @IBInspectable
    var scale:CGFloat = 0.9 { didSet{setNeedsDisplay()}}
    
    @IBInspectable
    var circleColor:UIColor = UIColor.blueColor() { didSet{setNeedsDisplay()} }

    @IBInspectable
    var lineWidth:CGFloat = 1 { didSet{setNeedsDisplay()}}
    
    var circleCenter:CGPoint {
        get {
            return convertPoint(center, fromView: superview)
        }
    }
    
    var circleRadius:CGFloat {
        get {
            return min(bounds.size.width, bounds.size.height) / 2 * scale
        }
    }

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(arcCenter: self.circleCenter,
            radius: self.circleRadius, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = self.lineWidth
        circleColor.setStroke()
        path.stroke()
    }
    

}
