//
//  SideViewController.swift
//  GetOnTrip
//
//  Created by guojinli on 15/7/27.
//  Copyright (c) 2015年 Joshua. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //MASK: Properties
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var headButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    var logined: Bool = true
    
    var headImage: UIImage? {
        didSet {
            headButton.setBackgroundImage(headImage, forState: UIControlState.Normal)
        }
    }
    
    var userName: String? {
        didSet {
            if let name = userName {
                welcome.text = "Hello! \(name)"
            }
        }
    }
    
    var bgImageUrl: String? {
        didSet {
            if let url = bgImageUrl {
            }
        }
    }

    //MASK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        refresh()
    }
    
    func refresh() {
        if logined {
            headImage = UIImage(named: "default-header")
            userName  = "Joshua"
            headButton.layer.cornerRadius = headButton.frame.width / 2
            headButton.clipsToBounds = true
            headButton.setTitle("", forState: .Normal)
            
        }else {
            headButton.hidden = true
        }
    }
    
}
