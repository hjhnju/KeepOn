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
    
    func insertRow(varId: Int, date: NSDate, value: CGFloat) -> Int {
        
        var ctx = self.managedObjectContext!
        
        let valueMap = NSEntityDescription.insertNewObjectForEntityForName("VariableValues", inManagedObjectContext: ctx) as! VariableValuesManagedObject
        valueMap.setValue(varId, forKey: "varId")
        valueMap.setValue(date, forKey: "date")
        valueMap.setValue(value, forKey: "value")
        
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
    
    //字典是无序的，结果需要使用者自己排序了
    func findAllOf(id: Int) -> [NSDate: CGFloat] {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("VariableValues", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "varId = %i", id)
        
        var error: NSError? = nil
        var retlistData     = [NSDate: CGFloat]()
        var listData        = ctx.executeFetchRequest(fetchRequest, error: &error)
        if let list = listData {
            for item in list {
                let mo = item as! VariableValuesManagedObject
                retlistData[mo.date] = mo.value as? CGFloat
            }
        }
        return retlistData
    }
    
}