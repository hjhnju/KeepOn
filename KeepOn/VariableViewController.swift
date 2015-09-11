//
//  VariableViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import ANDLineChartView

class VariableViewController: UIViewController, ANDLineChartViewDataSource, ANDLineChartViewDelegate {

    var variable: Variable!
    
    var chartView: ANDLineChartView!
    
    var values = [CGFloat]() {
        didSet {
            self.chartView.reloadData()
        }
    }
    //每个点的标签
    var labels = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        chartView = ANDLineChartView()
        chartView.dataSource = self
        chartView.delegate = self
        chartView.animationDuration = 0.4
        
        chartView.chartBackgroundColor = UIColor.whiteColor()
        chartView.gridIntervalLinesColor = UIColor.lightGrayColor()
        chartView.elementFillColor = UIColor.orangeColor()
        chartView.elementStrokeColor = UIColor.clearColor()
        chartView.gridIntervalFontColor = UIColor.orangeColor()
        chartView.lineColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
        
        self.view.addSubview(chartView)
        self.view.sendSubviewToBack(chartView)
        
        self.chartView.frame = self.view.bounds
        self.chartView.scrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.parentViewController?.title = variable.name
        self.variable.loadData()
        
        let formater = NSDateFormatter()
        formater.dateFormat = "MM-dd"
        
        //根据值更新
        var keys = Array(self.variable.valueMap.keys)
        sort(&keys){
            (d1:NSDate, d2:NSDate) -> Bool in
            let cmp = d1.compare(d2)
            return cmp == NSComparisonResult.OrderedAscending ? true : false
        }
        var values = [CGFloat]()
        for key in keys {
            if let value = self.variable.valueMap[key] {
                values.append(value)
                labels.append(formater.stringFromDate(key))
            }
        }
        self.values = values
    }
    
    
    func addItem(sender: UIBarButtonItem){
        
        let nav = UIStoryboard(name: "Variable", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.NavAddVarItemViewControllerID) as! UINavigationController
        if let addVarItemViewController = nav.visibleViewController as? AddVarItemViewController {
            addVarItemViewController.variable = self.variable
        }
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: ANDLineChartViewDataSource
    
    func numberOfElementsInChartView(chartView: ANDLineChartView!) -> UInt {
        return UInt(variable.valueMap.count)
    }
    
    func numberOfGridIntervalsInChartView(chartView: ANDLineChartView!) -> UInt {
        let num = UInt(self.maxValueForGridIntervalInChartView(chartView) - self.minValueForGridIntervalInChartView(chartView) + 1)
        return num
    }
    
    func chartView(chartView: ANDLineChartView!, valueForElementAtRow row: UInt) -> CGFloat {
        let row = Int(row)
        return self.values[row]
    }
    
    func chartView(chartView: ANDLineChartView!, descriptionForGridIntervalValue interval: CGFloat) -> String! {
        return String(format: "%.1f", interval)
    }

    
    func maxValueForGridIntervalInChartView(chartView: ANDLineChartView!) -> CGFloat {
        
        var retMax: Int = 5
        if let max = variable.maxValue {
            retMax = 5 + Int(max)
        }
        return CGFloat(retMax)
    }
    
    func minValueForGridIntervalInChartView(chartView: ANDLineChartView!) -> CGFloat {
        var retMin: Int = -5
        if let min = variable.minValue {
            retMin = Int(min) - 5
        }
        return CGFloat(retMin)
    }
    
    // MARK: ANDLineChartViewDelegate
    
    func chartView(chartView: ANDLineChartView!, spacingForElementAtRow row: UInt) -> CGFloat {
        return (row == 0) ? 60.0 : 30.0
    }
    

}
