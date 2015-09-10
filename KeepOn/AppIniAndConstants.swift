//
//  StorybordID.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class AppIniOnline {
    static let BaseUri = "http://123.57.67.165:8301"
}

class AppIniDev {
    static let BaseUri = "http://123.57.46.229:8301"
}

class AppIni:AppIniDev {
}

struct StoryBoardIdentifier {
    
    //menu
    static let MenuViewControllerID = "MenuViewControllerID"
    static let MenuTabelCellID = "MenuTabelCellID"
    
    //diary
    static let DiaryNavViewControllerID = "DiaryNavViewControllerID"
    static let DiaryViewControllerID   = "DiaryViewControllerID"
    static let AddDiaryViewControllerID = "AddDiaryViewControllerID"
    static let AddDiaryNavViewControllerID = "AddDiaryNavViewControllerID"
    
    //variable
    static let VariableViewControllerID = "VariableViewControllerID"
    
    //segue
    static let ShowAddDiarySegue = "ShowAddDiarySegue"
    static let UnwindSaveSegue = "UnwindSaveSegue"
}

struct SceneColor {
    static let crystalGray = UIColor.grayColor().colorWithAlphaComponent(0.1)
    static let crystalWhite = UIColor.whiteColor().colorWithAlphaComponent(0.8)
}

struct SceneFont {
    static let heiti = "STHeitiSC-Light"
}