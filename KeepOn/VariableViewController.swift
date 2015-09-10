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

    var variable: Variable!
    
    @IBOutlet weak var chartView: ANDLineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        refresh()
    }
    
    func refresh(){
        self.parentViewController?.title = variable.name
    }
    
    
    func edit(sender: UIBarButtonItem){
        
        let nav = UIStoryboard(name: "Variable", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.VariableViewControllerID) as! UINavigationController
        if let addVarViewController = nav.visibleViewController as? AddVarViewController {
            addVarViewController.variable = self.variable
        }
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
