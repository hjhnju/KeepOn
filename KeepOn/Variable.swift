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
    
    var valueMap = [NSDate: CGFloat]()
    
    var maxValue: CGFloat?
    
    var minValue: CGFloat?
    
    init(id: Int, name: String){
        self.id    = id
        self.name  = name
        self.color = UIColor.orangeColor()
    }
    
    func loadData(){
        self.valueMap = VariableValuesDAO.instance.findAllOf(self.id)
        var max = self.maxValue ?? CGFloat.min
        var min = self.minValue ?? CGFloat.max
        for value in self.valueMap.values {
            if max < value {
                max = value
                self.maxValue = max
            }
            if min > value {
                min = value
                self.minValue = min
            }
        }
    }
    
}