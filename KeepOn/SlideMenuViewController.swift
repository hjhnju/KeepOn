//
//  SlideMenuViewController.swift
//  GetOnTrip
//  滑动菜单的控制器
//
//  Created by 何俊华 on 15/7/30.
//  Copyright (c) 2015年 Joshua. All rights reserved.

import UIKit

//定义侧边栏的两种状态（打开，关闭）枚举类型
enum SlideMenuState: Int {
    case Opening = 1
    case Closing
    mutating func toggle() {
        switch self {
        case .Closing:
            self = .Opening
        case .Opening:
            self = .Closing
        }
    }
}

struct SlideMenuOptions {
    //拉伸的宽度
    static let DrawerWidth: CGFloat = UIScreen.mainScreen().bounds.width * 0.65
    //高度
    static let DrawerHeight: CGFloat = UIScreen.mainScreen().bounds.height
    //定义侧边栏距离左边的距离，浮点型
    static var ToggleLeastOffSet : CGFloat  = 60.0
}

class SlideMenuViewController: UIViewController {
    
    //MASK: Properties
    
    //定义窗体主体Controller
    var mainViewController: UIViewController!
    
    //定义侧边栏的Controller
    var menuViewController: UIViewController!
    
    //定义当前侧边栏的状态
    var slideMenuState: SlideMenuState = SlideMenuState.Closing
    
    //用户拖动视图
    var panGestureRecognizer: UIPanGestureRecognizer!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    //用户touch的点位置
    var startLocation : CGPoint!
    
    //MASK: View Life Cycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(main: UIViewController?, menu: UIViewController?){
        super.init(nibName: nil, bundle: nil)
        
        self.mainViewController = main
        self.menuViewController = menu
        
        self.menuViewController = self.menuViewController ?? UIViewController()
        self.mainViewController = self.mainViewController ?? UIViewController()
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panGestureHandler:")
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureHandler:")
        
        updateMenuViewController()
        updateMainViewController()
    }
    
    func updateMainViewController() {
        //初始化蒙板
        self.refreshMask()
        
        //添加用户拖动事件
        self.mainViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func updateMenuViewController() {
        
        self.menuViewController.view.addGestureRecognizer(panGestureRecognizer)
        
        if (self.menuViewController.view.superview == nil){
            self.mainViewController.addChildViewController(menuViewController)
            self.mainViewController.view.addSubview(menuViewController.view)
            self.mainViewController.view.bringSubviewToFront(menuViewController.view)
        }
        
        //限制宽度
        self.menuViewController.view.frame = CGRect(x: -SlideMenuOptions.DrawerWidth, y: 0, width: SlideMenuOptions.DrawerWidth, height: SlideMenuOptions.DrawerHeight)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    //MASK: Gestures
    
    func tapGestureHandler(sender: UITapGestureRecognizer){
        if sender.state == .Ended {
            self.didClose()
        }
    }
    
    //用户拖动视图调用代理方法。
    func panGestureHandler(gesture: UIPanGestureRecognizer){
        //用户对视图操控的状态。
        var state    = gesture.state;
        var location = gesture.locationInView(self.menuViewController.view)
        var velocity = gesture.velocityInView(self.menuViewController.view)
        
        switch (state) {
        case UIGestureRecognizerState.Began:
            //记录用户开始点击的位置
            self.startLocation = location
            break;
        case UIGestureRecognizerState.Changed:
            var frame = self.menuViewController.view.frame
            let tranPoint = gesture.translationInView(self.menuViewController.view)
            let diff = location.x - startLocation.x
            if (tranPoint.x > 0){
                if (self.slideMenuState == SlideMenuState.Closing){
                    frame.origin.x = min(diff + frame.origin.x, 0)
                }
            }else{
                if (self.slideMenuState == SlideMenuState.Opening){
                    frame.origin.x = max(diff + frame.origin.x, -SlideMenuOptions.DrawerWidth)
                }
            }
            self.menuViewController.view.frame = frame
            break;
        case UIGestureRecognizerState.Ended:
            var frame = self.menuViewController.view.frame
            //表示用户需要展开
            let diff = location.x - startLocation.x
            let tranPoint = gesture.translationInView(self.menuViewController.view)
            if (tranPoint.x > SlideMenuOptions.ToggleLeastOffSet){
                self.didOpen()
            }else {
                self.didClose()
            }
            break;
        default:
            break;
        }
    }
    
    //打开侧边栏
    func didOpen(){
        var menuFrame = self.menuViewController.view.frame
        menuFrame.origin.x = 0
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations:{ self.menuViewController.view.frame = menuFrame; },
            completion: { (finished: Bool) -> Void in }
        )
        
        //将侧边栏的装填标记为打开状态
        self.slideMenuState = SlideMenuState.Opening
        
        self.refreshMask()

    }
    
    //关闭侧边栏
    func didClose(){
        //点击关闭时要将当前状态标记为关闭
        if slideMenuState == SlideMenuState.Opening {
            slideMenuState = SlideMenuState.Closing
        }
        //将主窗体的起始位置恢复到原始状态
        var menuFrame = self.menuViewController.view.frame
        menuFrame.origin.x = -SlideMenuOptions.DrawerWidth
        UIView.animateWithDuration(0.7,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1.0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: { self.menuViewController.view.frame = menuFrame; },
            completion: { (finished: Bool) -> Void in }
        )
        
        self.refreshMask()
    }
    
    func isOpening() -> Bool {
        return slideMenuState == SlideMenuState.Opening ? true : false
    }

    //更新蒙板状态
    func refreshMask() {
        if self.isOpening() {
            //self.mainViewController.view.addGestureRecognizer(self.tapGestureRecognizer)
        } else {
            //self.mainViewController.view.removeGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func toggleMenu(){
        if isOpening() {
            self.didClose()
        } else {
            self.didOpen()
        }
    }
}
