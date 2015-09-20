//
//  DiaryMap.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class DiaryMap {
    
    var finishDays: [NSDate: [Int:NSDate]]!
    
    var minDays: [Int:NSDate]!
    
    init(finishDays: [NSDate: [Int:NSDate]]) {
        self.finishDays = finishDays
        self.minDays    = [Int:NSDate]()
    }
    
    //判断是否是已达成任务的日期
    func isFinishDay(diaryId: Int, date: NSDate) -> Bool {
        if let map = self.finishDays[date] {
            if let _ = map[diaryId] {
                return true
            }
        }
        return false
    }
    
    //取消已达成状态
    func cancelFinishDayForDiary(diaryId: Int, date: NSDate) -> Bool {
        
        let value = self.finishDays[date]?.removeValueForKey(diaryId)
        if self.finishDays[date]?.isEmpty == true {
            self.finishDays.removeValueForKey(date)
        }
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        NSLog("[CancelFinish]diary=\(diaryId), day=\(formater.stringFromDate(date))")
        
        return value == nil ? false : true
    }
    
    //确定达成任务
    func confirmFinishDayForDiary(diaryId: Int, finishDay: NSDate, optTime: NSDate) -> Bool {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        NSLog("[ConfirmFinish]diary=\(diaryId), finishDay=\(formater.stringFromDate(finishDay))")
        
        if self.finishDays[finishDay] == nil {
            self.finishDays[finishDay] = [diaryId: optTime]
        } else {
            self.finishDays[finishDay]![diaryId] = optTime
        }
        
        return true
    }
    
    //该天是否还有其他事件达成
    func hasOtherEventForDiaryDay(diaryId: Int, date: NSDate) -> Bool {
        if let map = self.finishDays[date] {
            if map.count == 1 {
                if let _ = map[diaryId] {
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
    func finishedDaysInMonthForDiary(diaryId: Int, monthDate: NSDate) -> Int {
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-01 00:00:00"
        let strFirstDate = formater.stringFromDate(monthDate)
        let firstDate    = formater.dateFromString(strFirstDate)!
        
        var endDate = firstDate
        if let end = firstDate.sameDateByAddingMonths(1) {
            endDate = end
        }
        
        return finishedDaysByDuration(diaryId, startDate:firstDate, endDate: endDate)
    }
    
    //总共完成天数
    func finishedDaysForDiary(diaryId: Int) -> Int {
        //init
        var count = 0
        minDays.removeAll(keepCapacity: true)
        
        for (date, map) in self.finishDays {
            //1. 统计最早日期
            if let minDay  = minDays[diaryId] {
                if date.compare(minDay) == NSComparisonResult.OrderedAscending {
                    minDays[diaryId] = date
                }
            } else {
                minDays[diaryId] = date
            }
            
            //2. 统计总数
            if let _ = map[diaryId] {
                count += 1
            }
        }
        return count
    }
    
    //日历的最早日期
    func earlestDate(diaryId: Int) -> NSDate {
        return minDays[diaryId] ?? (NSDate.distantPast() )
    }
    
    private func finishedDaysByDuration(diaryId: Int, startDate: NSDate, endDate: NSDate) -> Int {
        var count: Int = 0
        for (date, map) in self.finishDays {
            let comptoStart = date.compare(startDate)
            if (comptoStart == NSComparisonResult.OrderedDescending || comptoStart == NSComparisonResult.OrderedSame)  && date.compare(endDate) == NSComparisonResult.OrderedAscending {
                if let _ = map[diaryId] {
                    count += 1
                }
            }
        }
        return count
    }

    
}