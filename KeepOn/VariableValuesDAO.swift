//
//  VariableValuesDAO.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class VariableValuesDAO: CoreDataDAO {
    
    class var instance: VariableValuesDAO {
        struct Static {
            static var instance: VariableValuesDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = VariableValuesDAO()
        }
        return Static.instance!
    }
    
    func insertRow(varId: Int, date: NSDate, value: NSDate) -> Int {
        
        var ctx = self.managedObjectContext!
        
        let diaryMap = NSEntityDescription.insertNewObjectForEntityForName("VariableValues", inManagedObjectContext: ctx) as! NSManagedObject
        diaryMap.setValue(varId, forKey: "varId")
        diaryMap.setValue(date, forKey: "date")
        diaryMap.setValue(value, forKey: "value")
        
        var error: NSError? = nil
        if ctx.hasChanges && !ctx.save(&error) {
            NSLog("插入数据失败:\(error), \(error!.userInfo)")
            return -1
        }
        return 1
    }
    
    func removeRow(varId: Int, date: NSDate) -> Int{
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("VariableValues", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "varId = %i and date = %@", varId, date)
        
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
    
    func findAll() -> [NSDate: Float] {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("VariableValues", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        var sortDescriptors = NSArray(objects: sortDescriptor)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var retlistData = [NSDate: Float]()
        var listData = ctx.executeFetchRequest(fetchRequest, error: &error)
        if let list = listData {
            for item in list {
                let mo = item as! VariableValuesManagedObject
                retlistData[mo.date] = mo.value as? Float
            }
        }
        
        return retlistData
    }
    
}