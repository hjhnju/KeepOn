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
    static var diaryMap: DiaryMap = DiaryMapDAO.instance.findAll()
    
    var id: Int!
    
    var name: String!
    
    var color: UIColor = UIColor.orangeColor()
    
    var icon: String = "menu-diary"
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    //判断是否是已达成任务的日期
    func isFinishDay(date: NSDate) -> Bool {
        return Diary.diaryMap.isFinishDay(self.id, date: date)
    }
    
    //取消已达成状态
    func cancelFinishDay(date: NSDate) -> Bool {
        
        let success = Diary.diaryMap.cancelFinishDayForDiary(self.id, date: date)
        if success {
            DiaryMapDAO.instance.removeRow(self.id, finishDay: date)
        }
        return success
    }
    
    //确定达成任务
    func finishDay(date: NSDate) -> Bool {
        let optTime = NSDate()
        let success = Diary.diaryMap.confirmFinishDayForDiary(self.id, finishDay: date, optTime: optTime)
        if success {
            DiaryMapDAO.instance.insertRow(self.id, finishDay: date, optTime: optTime)
        }
        return success
    }
    
    //该天是否还有其他事件达成
    func hasOtherEventForDay(date: NSDate) -> Bool {
        return Diary.diaryMap.hasOtherEventForDiaryDay(self.id, date: date)
    }
    
    //当月完成天数，参数可能是当月的任何一天
    func finishedDaysInMonth(monthDate: NSDate) -> Int {
        return Diary.diaryMap.finishedDaysInMonthForDiary(self.id, monthDate: monthDate)
    }
    
    //总共完成天数
    func finishedDays() -> Int {
        return Diary.diaryMap.finishedDaysForDiary(self.id)
    }
    
    //日历的最早日期
    func earlestDate() -> NSDate {
        return Diary.diaryMap.earlestDate(self.id)
    }
}