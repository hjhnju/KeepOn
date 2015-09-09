//
//  Variable.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation
import UIKit

class Variable {
    
    var name: String!
    
    var id: Int!
    
    var color: UIColor!
    
    var icon = "menu-index"
    
    var valueMap = [NSDate: Float]()
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
        self.color = UIColor.orangeColor()
    }
    
}