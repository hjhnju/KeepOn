//
//  File.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/6.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

extension NSDate {
    func sameDateByAddingMonths(addMonths: Int) -> NSDate? {
    
        let calendar = NSCalendar.currentCalendar()
    
        let components = NSDateComponents()
        components.month = addMonths
    
        let nextMonthDate = calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions.allZeros)
        
        return nextMonthDate
    }

}