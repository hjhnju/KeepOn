//
//  AddDiaryViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController {
    
    var diary: Diary?
    
    var name: String! {
        get {
            return diaryNameField.text ?? "Default Diary"
        }
        set {
            if let value = newValue {
                diaryNameField.text = newValue
            }
        }
    }
    
    var colors = [UIColor.orangeColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.greenColor(), UIColor.lightGrayColor()]
    
    var colorIndex: Int! {
        get {
            return 0
        }
        set {
            //set colorPickView index
        }
    }

    @IBOutlet weak var diaryNameLabel: UILabel!
    @IBOutlet weak var diaryNameField: UITextField!
    
    @IBOutlet weak var colorPickLabel: UILabel!
    @IBOutlet weak var colorPickView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPickView.backgroundColor = UIColor.clearColor()
        saveButton.layer.cornerRadius = 3
        
        if diary != nil {
            self.title = "编辑日历"
            self.name = diary?.name
            self.saveButton.setTitle("保存", forState: UIControlState.Normal)
        } else {
            self.title = "新建日历"
            self.saveButton.setTitle("现在开始吧", forState: UIControlState.Normal)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoryBoardIdentifier.UnwindSaveSegue {
            save()
        }
    }

    private func save() {
        if diary == nil {
            self.createNewDiary()
        } else {
            self.updateDiary()
        }
    }
    
    private func createNewDiary() {
        let lastMaxID = DiaryPlistDAO.instance.getAvailableMaxDiaryId()
        diary        = Diary(id: lastMaxID, name: self.name)
        diary?.color = UIColor.blueColor()
        DiaryDAO.instance.create(diary!)
    }
    
    private func updateDiary(){
        diary?.name  = name
        diary?.color = colors[colorIndex]
        DiaryDAO.instance.modify(diary!)
    }
}
