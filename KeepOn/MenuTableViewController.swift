//
//  MenuTableViewController.swift
//  GetOnTrip
//
//  Created by 何俊华 on 15/7/31.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

struct TableViewConstants {
    //item types
    static let Diary = 0
    static let Index = 1
    static let Setting = 2
    
    //header inset
    static let EdgeInsetForCell: CGFloat = 10
}

class MenuTableViewController: UITableViewController {
    
    //MASK: Properties
    
    var menuOverview:[Int: Dictionary<String, String>] = [
        0:["text":"添加新日历", "icon":"menu-setting", "segue":"ShowAddDiarySegue"],
    ]

    var menuDiary = [Diary]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var menuIndex = [Variable]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sectionTitle:[String] = ["日历", "指数", "设置"]
    
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
    
    override func viewDidAppear(animated: Bool) {
        menuDiary = DiaryDAO.instance.findAll()
        menuIndex = VariableDAO.instance.findAll()
        if menuIndex.count == 0 {
            //为空则默认创建一个
            let id = PlistDAO.instance.getAutoIncreasedMaxId()
            let index = Variable(id: id, name: "MyIndex One")
            VariableDAO.instance.create(index)
            
            menuIndex = VariableDAO.instance.findAll()
        }
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
        return sectionTitle.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Tells the data source to return the number of rows in a given section of a table view. (required)
        var num: Int = 0
        switch section {
        case TableViewConstants.Setting:
            num = menuOverview.count
            break
        case TableViewConstants.Diary:
            num = menuDiary.count
            break
        case TableViewConstants.Index:
            num = menuIndex.count
        default:break
        }
        
        return num
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoardIdentifier.MenuTabelCellID, forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.section {
        case TableViewConstants.Setting:
            cell.textLabel?.text = menuOverview[indexPath.row]!["text"]!
            cell.imageView?.image = UIImage(named: menuOverview[indexPath.row]!["icon"]!)
            break
        case TableViewConstants.Diary:
            let diary = menuDiary[indexPath.row]
            cell.textLabel?.text = diary.name
            cell.imageView?.image = UIImage(named: diary.icon)
            //cell.imageView?.tintColor = diary.color
            break
        case TableViewConstants.Index:
            let index = menuIndex[indexPath.row]
            cell.textLabel?.text = index.name
            cell.imageView?.image = UIImage(named: index.icon)
            break
        default:break
        }
        
        cell.textLabel?.font = UIFont(name: SceneFont.heiti, size: 16)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        if title == nil {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        let headerHeight: CGFloat = 21
        let headerWidth: CGFloat  = tableView.frame.width - 2 * TableViewConstants.EdgeInsetForCell
        
        let label = UILabel()
        label.frame = CGRectMake(TableViewConstants.EdgeInsetForCell, 0, headerWidth, headerHeight)
        label.text = title
        label.font = UIFont(name: SceneFont.heiti, size: 12)
        
        let line   = UIView()
        line.frame = CGRectMake(TableViewConstants.EdgeInsetForCell, headerHeight-1, headerWidth, 0.5)
        line.backgroundColor = SceneColor.crystalWhite
        headerView.addSubview(line)
        
        headerView.addSubview(label)
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        let diaryViewController = self.parentViewController?.parentViewController as? DiaryViewController
        
        switch indexPath.section {
        case TableViewConstants.Setting:
            if let item = menuOverview[indexPath.row] {
                if let dvc = diaryViewController {
                    //dvc.performSegueWithIdentifier(item["segue"], sender: nil)
                    dvc.slideMenuViewController.toggleMenu()
                    let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(StoryBoardIdentifier.AddDiaryNavViewControllerID) as! UINavigationController
                    self.presentViewController(nav, animated: true, completion: nil)
                }
            }
            break
        case TableViewConstants.Diary:
            let diary = menuDiary[indexPath.row]
            
            if let dvc = diaryViewController {
                dvc.slideMenuViewController.toggleMenu()
                dvc.diary = diary
            }
        case TableViewConstants.Index:
            let index = menuIndex[indexPath.row]
            
            if let dvc = diaryViewController {
                dvc.slideMenuViewController.toggleMenu()
                
            }
            break
        default:break
        }
    }
}
