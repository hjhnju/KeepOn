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
    
    var manager: JTCalendarManager!
    
    @IBOutlet weak var calMenuView: JTCalendarMenuView!
    @IBOutlet weak var calWeekDayView: JTCalendarWeekDayView!
    @IBOutlet weak var calVerticalView: JTVerticalCalendarView!
    
    @IBOutlet weak var descView: UIView!
    @IBOutlet weak var monthCountLabel: UILabel!
    @IBOutlet weak var monthTipLabel: UILabel!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        //descview
        descView.backgroundColor = SceneColor.crystalGray
        
        monthCountLabel.font = UIFont(name: SceneFont.heiti, size: 48)
        totalCountLabel.font = UIFont(name: SceneFont.heiti, size: 48)
        monthTipLabel.font   = UIFont(name: SceneFont.heiti, size: 12)
        totalTipLabel.font   = UIFont(name: SceneFont.heiti, size: 12)
        
        
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
        
        refresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        if diary == nil {
            //优先所见的最后视图
            if let id = DiaryPlistDAO.instance.getLastViewDiaryId() {
                diary = DiaryDAO.instance.findById(id)
            }
            //无则第一则日历
            else {
                let diarys = DiaryDAO.instance.findAll()
                diary = diarys.first
            }
            
            //还为空则默认创建一个
            if diary == nil {
                let id = DiaryPlistDAO.instance.getAvailableMaxDiaryId()
                diary = Diary(id: id, name: "KeepOn Diary One")
                DiaryDAO.instance.create(diary)
            }
        } else {
            diary = DiaryDAO.instance.findById(diary.id)
        }
        
        DiaryPlistDAO.instance.setLastViewDiaryId(diary.id)
    }
    
    //refresh diary data
    func refresh() {
        
        let labelColor: UIColor = diary?.color ?? UIColor.orangeColor()
        monthCountLabel.textColor = labelColor
        totalCountLabel.textColor = labelColor
        monthTipLabel.textColor   = labelColor
        totalTipLabel.textColor   = labelColor
        
        self.title = diary?.name
        self.parentViewController?.title = diary?.name
        
        self.manager.reload()
        
        refreshMonthLabel()
        refreshTotalLabel()
    }
    
    func refreshMonthLabel(){
        let monthDate = calVerticalView.date
        let count = diary?.finishedDaysInMonth(monthDate) ?? 0
        self.monthCountLabel.text = "\(count)"
        
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM"
        let monthTip = "\(formater.stringFromDate(monthDate))当月达成天数"
        self.monthTipLabel.text = monthTip
    }
    
    func refreshTotalLabel(){
        let count = diary?.finishedDays() ?? 0
        self.totalCountLabel.text = "\(count)"
        
        if let earlestDate = diary?.earlestDate() {
            let formater = NSDateFormatter()
            formater.dateFormat = "yyyy/MM/dd"
            let earlestDay = formater.stringFromDate(earlestDate)
            self.totalTipLabel.text = "\(earlestDay)起累计天数"
        }
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
        dv.dotView.backgroundColor = diary?.color
        dv.textLabel.textColor     = UIColor.blackColor()
        let now = NSDate()
        
        //非本月日期不显示
        if dv.isFromAnotherMonth {
            dv.hidden = true
        }
        
        //当天日期
        if calendar.dateHelper.date(now, isTheSameDayThan: dv.date) {
            
            let emptyCircleColor      = diary?.color ?? UIColor.lightGrayColor()
            dv.textLabel.textColor    = emptyCircleColor
            dv.emptyCircleView.hidden = false
            dv.emptyCircleView.circleColor = emptyCircleColor
        }
        
        //其他月份的日期视图
        if !calendar.dateHelper.date(calVerticalView.date, isTheSameMonthThan: dv.date) {
            dv.textLabel.textColor = UIColor.lightGrayColor()
        }
        
        //有任务达成的日期，显示“圈”
        if diary?.isFinishDay(dv.date) == true {
            dv.circleView.hidden          = false
            dv.circleView.backgroundColor = diary.color
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
        
        refreshMonthLabel()
        refreshTotalLabel()
    }
    
    func calendarBuildDayView(calendar: JTCalendarManager!) -> UIView! {
        let dayView = DiaryDayView()
        dayView.circleRatio = 0.7
        return dayView
    }
    
    func calendarDidLoadNextPage(calendar: JTCalendarManager!) {
        refreshMonthLabel()
    }
    
    func calendarDidLoadPreviousPage(calendar: JTCalendarManager!) {
        refreshMonthLabel()
    }
    
    // MARK: Segues
    
    func edit(sender: UIBarButtonItem) {
        
        let nav = UIStoryboard(name: "Diary", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.AddDiaryNavViewControllerID) as! UINavigationController
        if let addDiaryViewController = nav.visibleViewController as? AddDiaryViewController {
            addDiaryViewController.diary = self.diary
        }
        self.presentViewController(nav, animated: true, completion: nil)
    }

}

