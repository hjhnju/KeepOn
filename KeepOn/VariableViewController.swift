//
//  VariableViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit
import ANDLineChartView

class VariableViewController: UIViewController {

    var slideMenuViewController: SlideMenuViewController!
    
    @IBOutlet weak var chartView: ANDLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        let menuViewController = UIStoryboard(name: "Menu", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MenuViewControllerID) as! UIViewController
        
        slideMenuViewController = SlideMenuViewController(main: self, menu: menuViewController)
    }

}
