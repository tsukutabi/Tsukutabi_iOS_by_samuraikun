//
//  ViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/27.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ArticleTableViewControllerDelegate {
    
    var pageMenu: CAPSPageMenu?
    let Aqua = UIColor(red: 0, green: 255, blue: 255, alpha: 1.0)
    let black = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    
    //サイトURL
    let wiredURL = "http://wired.jp/rssfeeder/"
    let shikiURL = "http://www.100shiki.com/feed"
    let cinraURL = "http://www.cinra.net/rss-all.xml"
    
    // didSelectTableViewCell()メソッドによって受け渡されてきた記事を保持しておくための変数
    var currentSelectedArticle: Article?
    
    // ナビゲーションタブバーの実装
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
        
        // MARK: - UI Setup
        
        self.navigationItem.title = "TSUKUTABI"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orangeColor()]
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<-", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToLeft")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "->", style: UIBarButtonItemStyle.Done, target: self, action: "didTapGoToRight")
    }
    
    // 記事テーブルの実装
    override func viewDidLoad() {
        // Initialize view controllers to display and place in array
        
        var controllerArray : [UIViewController] = []
        
        let controller1 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller1.title = "USA"
        controller1.loadRSS(wiredURL)
        controllerArray.append(controller1)
        controller1.customDelegate = self
        
        let controller2 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller2.title = "JAPAN"
        controller2.loadRSS(shikiURL)
        controllerArray.append(controller2)
        controller2.customDelegate = self
        
        let controller3 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller3.title = "FRANCE"
        controller3.loadRSS(wiredURL)
        controllerArray.append(controller3)
        controller3.customDelegate = self
        
        let controller4 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller4.title = "THAILAND"
        controller4.loadRSS(shikiURL)
        controllerArray.append(controller4)
        controller4.customDelegate = self
        
        let controller5 : ArticleTableViewController = ArticleTableViewController(nibName: "ArticleTableViewController", bundle: nil)
        controller5.title = "GERMAN"
        controller5.loadRSS(wiredURL)
        controllerArray.append(controller5)
        controller5.customDelegate = self
        
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
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
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height - 44), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
        
    }
    
    func didTapGoToLeft() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex > 0 {
            pageMenu!.moveToPage(currentIndex - 1)
        }
    }
    
    func didTapGoToRight() {
        let currentIndex = pageMenu!.currentPageIndex
        
        if currentIndex < pageMenu!.controllerArray.count {
            pageMenu!.moveToPage(currentIndex + 1)
        }
    }
    
    func didSelectTableViewCell(article: Article) {
        print("セルがタップされました")
        self.currentSelectedArticle = article
        self.performSegueWithIdentifier("ShowToContentViewController", sender: nil)
    }
    
    // 画面遷移時に値を遷移先に渡す(各記事にあった記事ページの移動の条件づけを行う)
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let contentViewController = segue.destinationViewController as! ContentViewController
        contentViewController.article = self.currentSelectedArticle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

