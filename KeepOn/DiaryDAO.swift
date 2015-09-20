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
        
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor] //.sortDescriptors = sortDescriptors as! [

        var retlistData = [Diary]()
        var listData: [AnyObject]?
        do {
            listData = try ctx.executeFetchRequest(fetchRequest)
        } catch let error as NSError {
            NSLog("请求失败:\(error), \(error.userInfo)")
            listData = nil
        }
        if let list = listData {
            for item in list {
                let diary = createFromMO(item as! NSManagedObject)
                retlistData.append(diary)
            }
        }
        return retlistData
    }
    
    func findById(id: Int) -> Diary? {
        
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            let listData = try ctx.executeFetchRequest(fetchRequest)
            if listData.count > 0 {
                let diary = createFromMO(listData.last as! NSManagedObject)
                return diary
            }
        } catch let error as NSError {
            
            NSLog("请求失败:\(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func create(model: Diary) -> Int {
        let ctx = self.managedObjectContext!
        
        let diary = NSEntityDescription.insertNewObjectForEntityForName("Diary", inManagedObjectContext: ctx) 
        diary.setValue(model.id, forKey: "id")
        diary.setValue(model.name, forKey: "name")
        diary.setValue(model.color, forKey: "color")
        
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
    
    func remove(model: Diary) -> Int {
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", model.id)
        
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
                }            }
        } catch let error as NSError {
            NSLog("请求失败:\(error), \(error.userInfo)")
        }
        return 0
    }
    
    func modify(model: Diary) -> Int {
        let ctx = self.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Diary", inManagedObjectContext: ctx)
        
        let fetchRequest       = NSFetchRequest()
        fetchRequest.entity    = entity
        fetchRequest.predicate = NSPredicate(format: "id = %i", model.id)
        
        do {
            let listData = try ctx.executeFetchRequest(fetchRequest)
            if listData.count > 0 {
                let mo = listData.last as! NSManagedObject
                self.updateFromModel(mo, model: model)
                
                if ctx.hasChanges {
                    do {
                        try ctx.save()
                    } catch let error as NSError {
                        NSLog("修改数据失败:\(error), \(error.userInfo)")
                        return -1
                    }
                }
            }
        } catch let error as NSError {
            NSLog("请求失败:\(error), \(error.userInfo)")
        }
        return 0
    }
    
    //从MangedObject获得Diary
    private func createFromMO(mo: NSManagedObject) -> Diary {
        let id        = mo.valueForKey("id") as! Int
        let name      = mo.valueForKey("name") as! String
        let color     = mo.valueForKey("color") as! UIColor
        
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
