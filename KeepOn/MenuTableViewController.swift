//
//  MenuTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

struct ItemType {
    static let Overview = -1
    static let Diary = 0
    static let Index = 1
}

class MenuTableViewController: UITableViewController {
    
    //MASK: Properties
    
    var menuTotal:[Int: Dictionary<String, String>] = [
        0:["text":"仪表盘", "icon":""],
    ]

    var menuDiary:[Int: Diary] = [
        1: Diary(id: 2, name: "膝盖锻炼"),
        0: Diary(id: 1, name: "郑多燕有氧操"),
    ]
    
    var menuVariable:[Int: Dictionary<String, String>] = [
        0:["text":"体重", "icon":""],
    ]
    
    var menuSectionData:[Int: Dictionary<String, String>] = [
        0:["title":"日历", "items":"2"],
        1:["title":"指数", "items":"1"],
    ]
    
    //MASK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //移除底部空Cell
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.contentInset    = UIEdgeInsetsZero
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollEnabled   = false
        tableView.separatorStyle  = UITableViewCellSeparatorStyle.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MASK: Delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //设置下划线无缩进
        cell.separatorInset = UIEdgeInsetsZero
        //设置下划线无边界
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        //无底色
        cell.backgroundColor = UIColor.clearColor()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuSectionData.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Tells the data source to return the number of rows in a given section of a table view. (required)
        let cnt =  menuSectionData[section]!["items"]!
        return cnt.toInt()!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.MenuTabelCellID, forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.section {
        case ItemType.Overview:
            cell.textLabel?.text = menuTotal[indexPath.row]!["text"]!
            cell.imageView?.image = UIImage(named: menuTotal[indexPath.row]!["icon"]!)
            break
        case ItemType.Diary:
            let diary = menuDiary[indexPath.row]
            cell.textLabel?.text = diary?.name
            break
        case ItemType.Index:
            cell.textLabel?.text = menuVariable[indexPath.row]!["text"]!
            cell.imageView?.image = UIImage(named: menuVariable[indexPath.row]!["icon"]!)
            break
        default:break
        }
        
        cell.textLabel?.font = UIFont(name: SceneFont.heiti, size: 16)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuSectionData[section]!["title"]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        if title == nil {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        let headerHeight: CGFloat = 21
        let headerWidth: CGFloat  = tableView.frame.width
        
        let label = UILabel()
        label.frame = CGRectMake(0, 0, headerWidth, headerHeight)
        label.text = title
        label.font = UIFont(name: SceneFont.heiti, size: 12)
        
        let line   = UIView()
        line.frame = CGRectMake(0, headerHeight-1, headerWidth, 0.5)
        line.backgroundColor = SceneColor.crystalWhite
        headerView.addSubview(line)
        
        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.section {
        case ItemType.Overview:break
        case ItemType.Diary:
            let diary = menuDiary[indexPath.row]
            
            if let dvc = self.parentViewController?.parentViewController as? DiaryViewController {
                dvc.slideMenuViewController.toggleMenu()
                dvc.diary = diary
            }
        case ItemType.Index:break
        default:break
        }
    }
}
