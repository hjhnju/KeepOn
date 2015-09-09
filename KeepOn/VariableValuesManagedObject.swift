//
//  VariableValuesManagedObject.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import CoreData

@objc(VariableValuesManagedObject)
class VariableValuesManagedObject: NSManagedObject {

    @NSManaged var varid: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var value: NSNumber

}
