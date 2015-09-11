//
//  AddDiaryViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/7.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
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
    
    var colorNames = ["blue", "brown", "orange", "green", "gray"]
    
    var colors = [UIColor.blueColor(), UIColor.brownColor(), UIColor.orangeColor(), UIColor.greenColor(), UIColor.lightGrayColor()]
    
    var color: UIColor!
    
    @IBOutlet weak var diaryNameLabel: UILabel!
    @IBOutlet weak var diaryNameField: UITextField!
    
    @IBOutlet weak var colorPickLabel: UILabel!
    @IBOutlet weak var colorPickView: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //默认用orange
        var row = 2
        if diary != nil {
            self.title = "编辑日历"
            self.name = diary?.name
            self.saveButton.title = "保存"
            for i in 0..<colors.count {
                if colors[i] == diary!.color {
                    row = i
                }
            }
        } else {
            self.title = "新建日历"
            self.saveButton.title = "现在开始吧"
        }
        
        colorPickView.dataSource = self
        colorPickView.delegate = self
        colorPickView.selectRow(row, inComponent: 0, animated: true)
        
        self.color = self.diary?.color ?? UIColor.orangeColor()
        
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        self.save()
        //传值回上一层view
        self.dismissViewControllerAnimated(true, completion: nil)
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
        diary?.color = self.color
        DiaryDAO.instance.create(diary!)
    }
    
    private func updateDiary(){
        diary?.name  = name
        diary?.color = self.color
        DiaryDAO.instance.modify(diary!)
    }
    
    //MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return colorNames.count
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return colorNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        color = colors[row]
    }
}
