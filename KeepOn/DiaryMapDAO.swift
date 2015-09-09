//
//  DiaryMap.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DiaryMapDAO: CoreDataDAO {
    
    class var instance: DiaryMapDAO {
        struct Static {
            static var instance: DiaryMapDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DiaryMapDAO()
        }
        return Static.instance!
    }
    
    func insertRow(diaryId: Int, finishDay: NSDate, optTime: NSDate) -> Int {
        
        var ctx = self.managedObjectContext!
        
        let diaryMap = NSEntityDescription.insertNewObjectForEntityForName("DiaryMap", inManagedObjectContext: ctx) as! NSManagedObject
        diaryMap.setValue(diaryId, forKey: "diaryId")
        diaryMap.setValue(finishDay, forKey: "finishDay")
        diaryMap.setValue(optTime, forKey: "optTime")
        
        var error: NSError? = nil
        if ctx.hasChanges && !ctx.save(&error) {
            NSLog("插入数据失败:\(error), \(error!.userInfo)")
            return -1
        }
        return 1
    }
    
    func removeRow(diaryId: Int, finishDay: NSDate) -> Int{
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryMap", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "diaryId = %i and finishDay = %@", diaryId, finishDay)
        
        var error: NSError? = nil
        if let listData = ctx.executeFetchRequest(fetchRequest, error: &error) {
            if listData.count > 0 {
                let mo = listData.last as! NSManagedObject
                ctx.deleteObject(mo)
                
                if ctx.hasChanges && !ctx.save(&error) {
                    NSLog("删除数据失败:\(error), \(error!.userInfo)")
                    return -1
                } else {
                    return 1
                }
            }
        }
        return 0
    }
    
    func findAll() -> DiaryMap {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryMap", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var sortDescriptor = NSSortDescriptor(key: "finishDay", ascending: true)
        var sortDescriptors = NSArray(objects: sortDescriptor)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var retlistData = [NSDate: [Int:NSDate]]()
        var listData = ctx.executeFetchRequest(fetchRequest, error: &error)
        if let list = listData {
            for item in list {
                let mo = item as! DiaryMapMangedObejct
                if retlistData[mo.finishDay] == nil {
                    retlistData[mo.finishDay] = [Int:NSDate]()
                }
                retlistData[mo.finishDay]![mo.diaryId as! Int] = mo.optTime
            }
        }
        
        let diaryMap = DiaryMap(finishDays: retlistData)
        return diaryMap
    }

}