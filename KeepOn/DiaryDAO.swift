//
//  DiaryDAO.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DiaryDAO: CoreDataDAO {
    
    class var instance: DiaryDAO {
        struct Static {
            static var instance: DiaryDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DiaryDAO()
        }
        return Static.instance!
    }
    
    func findAll() -> [Diary] {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        var sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        var sortDescriptors = NSArray(objects: sortDescriptor)
        fetchRequest.sortDescriptors = [sortDescriptor] //.sortDescriptors = sortDescriptors as! [
        var error: NSError? = nil
        var retlistData = [Diary]()
        var listData = ctx.executeFetchRequest(fetchRequest, error: &error)
        if let list = listData {
            for item in list {
                let diary = createFromMO(item as! NSManagedObject)
                retlistData.append(diary)
            }
        }
        return retlistData
    }
    
    func findById(id: Int) -> Diary? {
        
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        var error: NSError? = nil
        if let listData = ctx.executeFetchRequest(fetchRequest, error: &error) {
            if listData.count > 0 {
                let diary = createFromMO(listData.last as! NSManagedObject)
                return diary
            }
        }
        
        return nil
    }
    
    func create(model: Diary) -> Int {
        var ctx = self.managedObjectContext!
        
        let diary = NSEntityDescription.insertNewObjectForEntityForName("Diary", inManagedObjectContext: ctx) as! NSManagedObject
        diary.setValue(model.id, forKey: "id")
        diary.setValue(model.name, forKey: "name")
        diary.setValue(model.color, forKey: "color")
        
        var error: NSError? = nil
        if ctx.hasChanges && !ctx.save(&error) {
            NSLog("插入数据失败:\(error), \(error!.userInfo)")
            return -1
        }
        return 1
    }
    
    func remove(model: Diary) -> Int {
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
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
    
    func modify(model: Diary) -> Int {
        var ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
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
    private func createFromMO(mo: NSManagedObject) -> Diary {
        var id        = mo.valueForKey("id") as! Int
        var name      = mo.valueForKey("name") as! String
        var color     = mo.valueForKey("color") as! UIColor
        
        let diary       = Diary(id: id, name: name)
        diary.color     = color
        
        return diary
    }
    
    //从MangedObject获得Diary
    private func updateFromModel(mo: NSManagedObject, model: Diary) {
        mo.setValue(model.name, forKey:"name")
        mo.setValue(model.color, forKey:"color")
        
        return
    }
}
