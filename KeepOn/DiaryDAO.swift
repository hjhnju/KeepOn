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
                var mo = item as! NSManagedObject
                var id = mo.valueForKey("id") as! Int
                var name = mo.valueForKey("name") as! String
                var startDate = mo.valueForKey("startDate") as! NSDate
                var color = mo.valueForKey("color") as! UIColor
                let diary = Diary(id: id, name: name)
                diary.startDate = startDate
                diary.color = color
                retlistData.append(diary)
            }
        }
        return retlistData
    }
    
    func create(model: Diary) -> Int {
        var cxt = self.managedObjectContext!
        
        let diary = NSEntityDescription.insertNewObjectForEntityForName("Diary", inManagedObjectContext: cxt) as! NSManagedObject
        diary.setValue(model.id, forKey: "id")
        diary.setValue(model.name, forKey: "name")
        diary.setValue(model.startDate, forKey: "startDate")
        diary.setValue(model.color, forKey: "color")
        
        var error: NSError? = nil
        if cxt.hasChanges && !cxt.save(&error) {
            NSLog("插入数据失败:\(error), \(error!.userInfo)")
            return -1
        }
        return 1
    }
}
