//
//  ViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/27.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    let Aqua = UIColor(red: 0, green: 255, blue: 255, alpha: 1.0)
    let black = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: - UI Setup
        
        self.title = "TSUKUTABI_g"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToLeft")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToRight")
        
        // MARK: - Scroll menu setup
        
        // Initialize view controllers to display and place in array
        var controllerArray : [UIViewController] = []
        
        var controller1 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller1.title = "USA"
        controllerArray.append(controller1)
        
        var controller2 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller2.title = "JAPAN"
        controllerArray.append(controller2)
        
        var controller3 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller3.title = "FRANCE"
        controllerArray.append(controller3)
        
        var controller4 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller4.title = "THAILAND"
        controllerArray.append(controller4)
        
        var controller5 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller5.title = "GERMAN"
        controllerArray.append(controller5)
        
        
        // Customize menu (Optional)
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(black),
            .ViewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .BottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]
        
        // Initialize scroll menu
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
    
    func didTapGoToLeft() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        var currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

