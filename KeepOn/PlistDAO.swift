//
//  PlistDAO.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class PlistDAO {
    
    var resFile = "Diary.plist"
    
    var autokey = "AutoIncreasedMaxId"
    
    static var instance: PlistDAO {
        struct Static {
            static var instance: PlistDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = PlistDAO()
        }
        return Static.instance!
    }
    
    var path: String!
    
    var dataMap: NSDictionary!
    
    init(){
        path    = self.applicationDocumentsDirectoryFile()
        dataMap = NSMutableDictionary(contentsOfFile: path)
    }
    
    //返回一个自增的id
    func getAutoIncreasedMaxId() -> Int {
        
        var lastMaxId = 0
        if let id = dataMap?.valueForKey(self.autokey) as? Int {
            lastMaxId = id
        }
        
        dataMap?.setValue(lastMaxId + 1, forKey: self.autokey)
        dataMap.writeToFile(path, atomically: true)
        
        lastMaxId = dataMap?.valueForKey(self.autokey) as! Int
        
        return lastMaxId
    }
    
    //自定义文件目录路径
    private func applicationDocumentsDirectoryFile() -> String {
        let documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = documentDirectory[0].stringByAppendingPathComponent(self.resFile)
        
        //create if not exists
        let fileManager  = NSFileManager.defaultManager()
        let dbFileExists = fileManager.fileExistsAtPath(path)
        if !dbFileExists {
            let dbFile = self.resouceDocumentDirectoryFile(self.resFile)
            let success = fileManager.copyItemAtPath(dbFile, toPath: path, error: nil)
            
            assert(success, "无法生成存储文件")
        }
        
        return path
    }
    
    //Info.plist所在路径
    private func resouceDocumentDirectoryFile(fileName: String) -> String {
        let resoucePath = NSBundle.mainBundle().bundlePath
        let path = resoucePath.stringByAppendingPathComponent(fileName)
        
        return path
    }
    
    
}