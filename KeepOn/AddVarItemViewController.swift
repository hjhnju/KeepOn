//
//  AddVarItemViewController.swift
//  KeepOn
//
//  Created by 何俊华 on 15/9/9.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class AddVarItemViewController: UIViewController, UITextFieldDelegate{
    
    var variable: Variable?
    
    var name: String? {
        if !varNameField.text!.isEmpty {
            return varNameField.text
        }
        return nil
    }
    
    //表示一天的日期，"yyyy/MM/dd 00:00:00"
    var day: NSDate?
    
    var value: CGFloat? {
        if let text = valueTextField.text {
            if !text.isEmpty {
                return CGFloat((text as NSString).floatValue)
            }
        }
        return nil
    }

    @IBOutlet weak var varNameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.varNameField.text = self.variable?.name
        
        self.datePicker.datePickerMode = UIDatePickerMode.Date

        let maxDate = NSDate()
        let minDate = NSDate(timeIntervalSinceNow: -7*24*60*60)
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        datePicker.date = maxDate
        datePicker.addTarget(self, action:Selector("datePickerValueChange:"), forControlEvents: UIControlEvents.ValueChanged)
        
        valueTextField.delegate = self
        valueTextField.keyboardType = UIKeyboardType.DecimalPad
        valueTextField.becomeFirstResponder()
        
        self.day = sameDayFormate(datePicker.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM/dd"
        
        let alert   = UIAlertView()
        alert.title = "保存指数"
        
        var message = ""
        if let value = self.value {
            let v = NSString(format: "%.1f", value)
            message = "\(formater.stringFromDate(datePicker.date))的\(self.name!)值: \(v)"
        } else {
            message = "修改指数名为: \(self.name!)"
        }
        
        message += "\n\n若重复保存当天，则会覆盖旧值，请确认添加无误!"
        
        let alertController = UIAlertController(title: "保存指数", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        let cancelAction  = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// 响应 datePicker 事件
    func datePickerValueChange(sender: UIDatePicker) {
        self.day = sameDayFormate(sender.date)
    }
    
    private func save() -> Void {
        if let variable = self.variable {
            if let name = self.name {
                    variable.name = name
                VariableDAO.instance.modify(variable)
            }
            
            if let day = self.day {
                if let value = self.value {
                    let formater = NSDateFormatter()
                    formater.dateFormat = "yyyy/MM/dd HH:mm:ss"
                    NSLog("[AddIndexItem]\(variable.id),\(formater.stringFromDate(day)), \(value)")
                    VariableValuesDAO.instance.insertRow(variable.id, date: day, value: value)
                }
            }
        }
    }
    
    //MARK: UITextFieldDelegate
    
    //TODO: 当日指数只支持数值
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    private func sameDayFormate(date: NSDate) -> NSDate{
        let formater = NSDateFormatter()
        formater.dateFormat = "yyyy/MM/dd 00:00:00"
        return formater.dateFromString(formater.stringFromDate(date))!
    }
}
