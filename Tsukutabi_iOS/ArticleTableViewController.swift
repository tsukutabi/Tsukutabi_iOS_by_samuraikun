//
//  ArticleTableViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/27.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {
        
    var titlesArray : [String] = ["Hello Slicon Valley!!", "Golden Bridge!!", "Kim White", "Charles Gray", "Timothy Jones", "Sarah Underwood", "William Pearl", "Juan Rodriguez", "Anna Hunt", "Marie Turner", "George Porter", "Zachary Hecker", "David Fletcher"]
    
    var photoNameArray : [String] = ["woman5.jpg", "man1.jpg", "woman1.jpg", "man2.jpg", "man3.jpg", "woman2.jpg", "man4.jpg", "man5.jpg", "woman3.jpg", "woman4.jpg", "man6.jpg", "man7.jpg", "man8.jpg"]
    
    var backgroundArray : [String] = ["silicon_valley.jpg", "back2.jpg", "back3.jpg", "back4.jpg", "back5.jpg",
                                      "back6.jpg", "back7.jpg", "back8.jpg", "back9.jpg", "back10.jpg",
                                      "back11.jpg", "back12.jpg", "back13.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 13
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ArticleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell") as! ArticleTableViewCell
        
        // Configure the cell...
        cell.titleLabel.text = titlesArray[indexPath.row]
        cell.photoImageView.image = UIImage(named: photoNameArray[indexPath.row])
        cell.backImageView.image = UIImage(named: backgroundArray[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250.0
    }
    
}
