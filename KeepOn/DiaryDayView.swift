//
//  DiaryDayView.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import JTCalendar

class DiaryDayView: JTCalendarDayView {
    
    //空心圆
    var emptyCircleView: EmptyCircleView!
    
    override func commonInit() {
        super.commonInit()
        
        emptyCircleView = EmptyCircleView()
        self.addSubview(emptyCircleView)
        
        emptyCircleView.circleColor = UIColor.lightGrayColor()
        emptyCircleView.backgroundColor = UIColor.clearColor()
        emptyCircleView.hidden = true
        emptyCircleView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var sizeCircle: CGFloat = min(self.frame.size.width, self.frame.size.height)
        sizeCircle = round(sizeCircle * self.circleRatio) + 5;
        emptyCircleView.frame  = CGRectMake(0, 0, sizeCircle, sizeCircle);
        emptyCircleView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }

}
