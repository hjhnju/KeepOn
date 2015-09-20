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
        
        let ctx = self.managedObjectContext!
        
        let diaryMap = NSEntityDescription.insertNewObjectForEntityForName("DiaryMap", inManagedObjectContext: ctx) 
        diaryMap.setValue(diaryId, forKey: "diaryId")
        diaryMap.setValue(finishDay, forKey: "finishDay")
        diaryMap.setValue(optTime, forKey: "optTime")
        
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch let error as NSError {
                NSLog("插入数据失败:\(error), \(error.userInfo)")
                return -1
            }
        }
        return 1
    }
    
    func removeRow(diaryId: Int, finishDay: NSDate) -> Int{
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryMap", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "diaryId = %i and finishDay = %@", diaryId, finishDay)
        
        do {
            let listData = try ctx.executeFetchRequest(fetchRequest)
            if listData.count > 0 {
                let mo = listData.last as! NSManagedObject
                ctx.deleteObject(mo)
                
                if ctx.hasChanges {
                    do {
                        try ctx.save()
                    } catch let error as NSError {
                        NSLog("删除数据失败:\(error), \(error.userInfo)")
                        return -1
                    }
                }
            }
        } catch let error as NSError {
            NSLog("请求失败:\(error), \(error.userInfo)")
        }
        return 0
    }
    
    func findAll() -> DiaryMap {
        
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("DiaryMap", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "finishDay", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var retlistData = [NSDate: [Int:NSDate]]()
        var listData: [AnyObject]?
        do {
            listData = try ctx.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            NSLog("请求失败:\(error), \(error.userInfo)")
            listData = nil
        }
        if let list = listData {
            for item in list {
                let mo = item as! DiaryMapManagedObject
                if retlistData[mo.finishDay] == nil {
                    retlistData[mo.finishDay] = [Int:NSDate]()
                }
                retlistData[mo.finishDay]![mo.diaryId as Int] = mo.optTime
            }
        }
        
        let diaryMap = DiaryMap(finishDays: retlistData)
        return diaryMap
    }

}