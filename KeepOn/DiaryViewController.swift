//
//  DiaryViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/1.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import JTCalendar

class DiaryViewController: UIViewController, JTCalendarDelegate{
    
    var diary: Diary! {
        didSet {
            refresh()
        }
    }
    
    var slideMenuViewController: SlideMenuViewController!
    
    var manager: JTCalendarManager!
    
    @IBOutlet weak var calMenuView: JTCalendarMenuView!
    @IBOutlet weak var calWeekDayView: JTCalendarWeekDayView!
    @IBOutlet weak var calVerticalView: JTVerticalCalendarView!
    
    @IBOutlet weak var monthCountLabel: UILabel!
    @IBOutlet weak var monthTipLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        let menuViewController = UIStoryboard(name: "Menu", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MenuViewControllerID) as! UIViewController
        
        slideMenuViewController = SlideMenuViewController(main: self, menu: menuViewController)
        
        //calendar
        calMenuView.backgroundColor     = UIColor.whiteColor()
        calWeekDayView.backgroundColor  = UIColor.whiteColor()
        calVerticalView.backgroundColor = UIColor.whiteColor()
        
        manager = JTCalendarManager()
        manager.delegate = self
        
        manager.settings.pageViewHaveWeekDaysView = false
        manager.settings.pageViewNumberOfWeeks = 0
        manager.settings.weekDayFormat = JTCalendarWeekDayFormat.Short;
        
        calWeekDayView.manager = manager
        calWeekDayView.reload()
        
        manager.menuView = calMenuView
        manager.contentView = calVerticalView
        manager.setDate(NSDate())
        
        calMenuView.scrollView.scrollEnabled = false
        
        if diary == nil {
            let diarys = DiaryDAO.instance.findAll()
            diary = diarys.first
        }
    }
    
    //refresh diary data
    func refresh() {
        self.title = diary.name
        self.manager.reload()
        
        
        let monthDate = manager.date()
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        NSLog("refresh=\(formater.stringFromDate(monthDate))")
        
        refreshMonth()
        refreshTotal()
    }
    
    func refreshMonth(){
        let monthDate = calVerticalView.date
        self.monthCountLabel.text = "\(diary.finishedDaysInMonth(monthDate))"
        self.monthTipLabel.text = getMonthTip(monthDate)
    }
    
    func refreshTotal(){
        self.totalTipLabel.text = getTotalTip()
        self.totalCountLabel.text = "\(diary.finishedDays())"
    }
    
    @IBAction func toggleMenu(sender: UIBarButtonItem) {
        slideMenuViewController.toggleMenu()
    }
    
    private func getMonthTip(month: NSDate) -> String {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM"
        let monthTip = "\(formater.stringFromDate(month))当月达成天数"
        return monthTip
    }
    
    private func getTotalTip() -> String {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        let totalTip = "\(formater.stringFromDate(diary!.startDate))起累计天数"
        return totalTip
    }
    
    //MARK: JTCalendarDelegate
    
    func calendar(calendar: JTCalendarManager!, prepareDayView dayView: UIView!) {
        //NSLog("prepareDayView, diary=\(diary)")
        
        let dv = dayView as! DiaryDayView
        //默认设置
        dv.hidden            = false
        dv.circleView.hidden = true
        dv.dotView.hidden    = true
        dv.emptyCircleView.hidden = true
        dv.dotView.backgroundColor = UIColor.orangeColor()
        dv.textLabel.textColor     = UIColor.blackColor()
        let now = NSDate()
        
        //非本月日期不显示
        if dv.isFromAnotherMonth {
            dv.hidden = true
        }
        
        //当天日期
        if calendar.dateHelper.date(now, isTheSameDayThan: dv.date) {
            dv.textLabel.textColor    = UIColor.lightGrayColor()
            dv.emptyCircleView.hidden = false
            dv.emptyCircleView.circleColor = UIColor.lightGrayColor()
        }
        
        //其他月份的日期视图
        if !calendar.dateHelper.date(calVerticalView.date, isTheSameMonthThan: dv.date) {
            dv.textLabel.textColor = UIColor.lightGrayColor()
        }
        
        //有任务达成的日期，显示“圈”
        if diary?.isFinishDay(dv.date) == true {
            dv.circleView.hidden          = false
            dv.circleView.backgroundColor = UIColor.orangeColor()
            dv.dotView.backgroundColor    = UIColor.whiteColor()
            dv.textLabel.textColor        = UIColor.whiteColor()
        }
        
        //若该日有其他事件则显示“点”
        if diary?.hasOtherEventForDay(dv.date) == true {
            dv.dotView.hidden = false
        }
    }
    
    func calendar(calendar: JTCalendarManager!, didTouchDayView dayView: UIView!) {
        
        let dv = dayView as! DiaryDayView
        
        //未来时间不可点击
        if dv.date.compare(NSDate()) == NSComparisonResult.OrderedDescending {
            return
        }
        
        //已完达成任务的日期，点击则取消
        if diary.isFinishDay(dv.date) {
            diary.cancelFinishDay(dv.date)
            UIView.transitionWithView(dv, duration: 0.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.manager.reload()
                dv.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
            }, completion: nil)
        } else {
            //未完成任务的日期，点击则确定完成
            diary.finishDay(dv.date)
            dv.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1)
            UIView.transitionWithView(dv, duration: 0.3, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                self.manager.reload()
                dv.circleView.transform = CGAffineTransformIdentity
            }, completion: nil)
        }
        
        refreshMonth()
        refreshTotal()
    }
    
    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let dayView = DiaryDayView()
        dayView.circleRatio = 0.7
        return dayView
    }
    
    func calendarDidLoadNextPage(calendar: JTCalendarManager!) {
        refreshMonth()
    }
    
    func calendarDidLoadPreviousPage(calendar: JTCalendarManager!) {
        refreshMonth()
    }

}
