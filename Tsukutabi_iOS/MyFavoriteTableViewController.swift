//
//  MyPageTableViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/09/06.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class MyFavoriteTableViewController: UITableViewController {
    
    let sectionNum = 1
    let cellNum = 10
    //let urlString = "http://api.openweathermap.org/data/2.5/forecast?units=metric&q=Tokyo"
    let urlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/computer/rss.xml&num=10"
    let realvoice = "http://realvoicenext.sakura.ne.jp/cakephp/posts/indexjson"
    
    // セルの中身
    var cellItems = NSMutableArray()
    // ロード中かどうか
    var isInLoad = false
    // 選択されたセルの列番号
    var selectedRow: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // json取得->tableに突っ込む
        makeTableData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    func makeTableData() {
        self.isInLoad = true
        let url = NSURL(string: self.urlString)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            let json = JSON(data: data!)
            // 各セルに情報を突っ込む
            for var i = 0; i < self.cellNum; i++ {
                let day = json["responseData"]["feed"]["entries"][i]["publishedDate"]
                let title = json["responseData"]["feed"]["entries"][i]["title"]
                let info = "\(title), \(day)"
                self.cellItems[i] = info
            }
            // ロードが完了したので、falseに
            self.isInLoad = false
        })
        task.resume()
        
        // 読み込みが終わるまで待機
        // (ゆる募)
        // 下の解決策以外に何か方法があればと。。。
        // jsonの取得に非同期通信を使ってるので、読み込むまで待ってからじゃないと
        // cellに値が入らない。同期通信使えって話もあるけど今後の拡張を考えてNSURLSession使ってます(^_^;)
        while isInLoad {
            usleep(10)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sectionNum
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.cellNum
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell", forIndexPath: indexPath) 
        cell.textLabel?.text = self.cellItems[indexPath.row] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
