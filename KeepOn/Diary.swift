//
//  Diary.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class Diary {
    
    //保存所有日历的任务达成纪录。［日期：［日历id: 操作时间］］
    static var finishDays = [NSDate: [Int:NSDate]]()
    
    var id: Int!
    
    var name: String!
    
    //开始的时间
    var startDate: NSDate = NSDate.distantPast() as! NSDate
    
    var color: UIColor = UIColor.orangeColor()
    
    var icon: String = "menu-diary"
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    //判断是否是已达成任务的日期
    func isFinishDay(date: NSDate) -> Bool {
        if let map = Diary.finishDays[date] {
            if let ret = map[self.id] {
                return true
            }
        }
        return false
    }
    
    //取消已达成状态
    func cancelFinishDay(date: NSDate) -> Void {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        NSLog("diary:\(self.id,self.name), cancelFinishDay=\(formater.stringFromDate(date))")
        
        Diary.finishDays[date]?.removeValueForKey(self.id)
        if Diary.finishDays[date]?.isEmpty == true {
            Diary.finishDays.removeValueForKey(date)
        }
    }
    
    //确定达成任务
    func finishDay(date: NSDate) -> Bool {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        NSLog("diary:\(self.id,self.name), finishDay=\(formater.stringFromDate(date))")
        
        if Diary.finishDays[date] == nil {
            Diary.finishDays[date] = [self.id: NSDate()]
        } else {
            Diary.finishDays[date]![self.id] = NSDate()
        }
        
        return true
    }
    
    //该天是否还有其他事件达成
    func hasOtherEventForDay(date: NSDate) -> Bool {
        if let map = Diary.finishDays[date] {
            if map.count == 1 {
                if let ret = map[self.id] {
                    return false
                } else {
                    return true
                }
            } else if map.count > 1 {
                return true
            }
        }
        return false
    }
    
    //当月完成天数，参数可能是当月的任何一天
    func finishedDaysInMonth(monthDate: NSDate) -> Int {
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-01 00:00:00"
        let strFirstDate = formater.stringFromDate(monthDate)
        let firstDate    = formater.dateFromString(strFirstDate)!
        
        var endDate = firstDate
        if let end = firstDate.sameDateByAddingMonths(1) {
            endDate = end
        }
        
        return finishedDaysByDuration(firstDate, endDate: endDate)
    }
    
    //总共完成天数
    func finishedDays() -> Int {
        let endDate = NSDate(timeIntervalSinceNow: 24*60*60)
        return finishedDaysByDuration(self.startDate, endDate: endDate)
    }
    
    private func finishedDaysByDuration(startDate: NSDate, endDate: NSDate) -> Int {
        var count: Int = 0
        for (date, map) in Diary.finishDays {
            let comptoStart = date.compare(startDate)
            if (comptoStart == NSComparisonResult.OrderedDescending || comptoStart == NSComparisonResult.OrderedSame)  && date.compare(endDate) == NSComparisonResult.OrderedAscending {
                if let id = map[self.id] {
                    count += 1
                }
            }
        }
        return count
    }
}