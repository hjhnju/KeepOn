//
//  Diary.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData

@objc(DiaryManagedObject)
class DiaryManagedObject: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var startDate: NSDate
    @NSManaged var color: AnyObject

}
