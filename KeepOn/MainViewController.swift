//
//  MainViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/10.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//
import Foundation
import UIKit

class MainViewController: UIViewController {
        
    var slideMenuViewController: SlideMenuViewController!
    
    private var currentMainSubviewController : UIViewController?{
        didSet {
            if let mws = currentMainSubviewController {
                self.addChildViewController(mws)
                self.view.addSubview(mws.view)
                self.view.sendSubviewToBack(mws.view)
            }
        }
    }
    
    var mainSubviewController: UIViewController? {
        didSet {
            if let nmws = mainSubviewController {
                currentMainSubviewController?.removeFromParentViewController()
                currentMainSubviewController?.view.removeFromSuperview()
                currentMainSubviewController = nmws
            }
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.whiteColor()
        
        //1.主界面
        if currentMainSubviewController == nil {
            //初始化一个日历
            let diaryViewController = UIStoryboard(name: "Diary", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.DiaryViewControllerID) as! DiaryViewController
            currentMainSubviewController = diaryViewController
        }
        //2.菜单
        let menuViewController = UIStoryboard(name: "Menu", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.MenuViewControllerID) as! UIViewController
        slideMenuViewController = SlideMenuViewController(main: self, menu: menuViewController)
    }
    
    @IBAction func showMenu(sender: UIBarButtonItem) {
        slideMenuViewController.toggleMenu()
    }
    
    @IBAction func showActions(sender: UIBarButtonItem) {
        if let cmvc = self.currentMainSubviewController as? DiaryViewController {
            cmvc.edit(sender)
        } else if let cmvc = self.currentMainSubviewController as? VariableViewController {
            cmvc.addItem(sender)
        }
    }
}
