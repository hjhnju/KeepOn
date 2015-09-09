//
//  VariableDAO.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class VariableDAO: CoreDataDAO {
    
    class var instance: VariableDAO {
        struct Static {
            static var instance: VariableDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = VariableDAO()
        }
        return Static.instance!
    }
    
    
    func findAll() -> [Variable] {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Variable", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        var sortDescriptors = NSArray(objects: sortDescriptor)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var retlistData = [Variable]()
        var listData = ctx.executeFetchRequest(fetchRequest, error: &error)
        if let list = listData {
            for item in list {
                let variable = createFromMO(item as! NSManagedObject)
                retlistData.append(variable)
            }
        }
        return retlistData
    }
    
    func findById(id: Int) -> Variable? {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Variable", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        var error: NSError? = nil
        if let listData = ctx.executeFetchRequest(fetchRequest, error: &error) {
            if listData.count > 0 {
                let variable = createFromMO(listData.last as! NSManagedObject)
                return variable
            }
        }
        
        return nil
    }
    
    func create(model: Variable) -> Int {
        var ctx = self.managedObjectContext!
        
        let variable = NSEntityDescription.insertNewObjectForEntityForName("Variable", inManagedObjectContext: ctx) as! NSManagedObject
        variable.setValue(model.id, forKey: "id")
        variable.setValue(model.name, forKey: "name")
        variable.setValue(model.color, forKey: "color")
        
        var error: NSError? = nil
        if ctx.hasChanges && !ctx.save(&error) {
            NSLog("插入数据失败:\(error), \(error!.userInfo)")
            return -1
        }
        return 1
    }
    
    func remove(model: Variable) -> Int {
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Variable", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", model.id)
        
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
    
    func modify(model: Variable) -> Int {
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Variable", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", model.id)
        
        var error: NSError? = nil
        if let listData = ctx.executeFetchRequest(fetchRequest, error: &error) {
            if listData.count > 0 {
                let mo = listData.last as! NSManagedObject
                self.updateFromModel(mo, model: model)
                
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
    
    //从MangedObject获得Diary
    private func createFromMO(mo: NSManagedObject) -> Variable {
        var id        = mo.valueForKey("id") as! Int
        var name      = mo.valueForKey("name") as! String
        var color     = mo.valueForKey("color") as! UIColor
        
        let variable   = Variable(id: id, name: name)
        variable.color = color
        
        return variable
    }
    
    //从MangedObject获得Diary
    private func updateFromModel(mo: NSManagedObject, model: Variable) {
        mo.setValue(model.name, forKey:"name")
        mo.setValue(model.color, forKey:"color")
        
        return
    }

}