//
//  DiaryMap.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData

@objc(DiaryMapManagedObject)
class DiaryMapManagedObject: NSManagedObject {

    @NSManaged var diaryId: NSNumber
    @NSManaged var finishDay: NSDate
    @NSManaged var optTime: NSDate

}
