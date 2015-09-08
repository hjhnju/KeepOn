//
//  DiaryPlistDAO.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/8.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import Foundation

class DiaryPlistDAO {
    
    var resFile = "Diary.plist"
    
    class var instance: DiaryPlistDAO {
        struct Static {
            static var instance: DiaryPlistDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = DiaryPlistDAO()
        }
        return Static.instance!
    }
    
    var path: String!
    
    var dataMap: NSDictionary!
    
    init(){
        path    = self.applicationDocumentsDirectoryFile()
        dataMap = NSMutableDictionary(contentsOfFile: path)
    }
    
    //获取最后看的那个日历id
    func getLastViewDiaryId() -> Int? {
        let lastViewDiaryId = dataMap?.valueForKey("lastViewDiaryId") as? Int
        return lastViewDiaryId
    }
    
    //设置最后看的那个日历id
    func setLastViewDiaryId(id: Int) -> Bool {
        dataMap?.setValue(id, forKey: "lastViewDiaryId")
        return dataMap.writeToFile(path, atomically: true)
    }
    
    //返回可用的DiaryId
    func getAvailableMaxDiaryId() -> Int {
        
        var lastMaxDiaryId = 0
        if let id = dataMap?.valueForKey("lastMaxDiaryId") as? Int {
            lastMaxDiaryId = id
        }
        
        dataMap?.setValue(lastMaxDiaryId + 1, forKey: "lastMaxDiaryId")
        dataMap.writeToFile(path, atomically: true)
        
        lastMaxDiaryId = dataMap?.valueForKey("lastMaxDiaryId") as! Int
        
        return lastMaxDiaryId
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