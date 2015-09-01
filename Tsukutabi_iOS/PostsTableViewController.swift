//
//  PostsTableViewController.swift
//  SwiftTsukutabitest
//
//  Created by Ryosei Takahashi on 2015/08/26.
//  Copyright (c) 2015年 Ryosei Takahashi. All rights reserved.
//

import UIKit
import CoreData


class PostsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {
    // セクションの数
    let sectionNum = 1
    // 1セクションあたりのセルの行数
    var cellNum = 10
    
    // 取得するAPI
    let urlString = "http://realvoicenext.sakura.ne.jp/cakephp/posts/indexjson"
    // セルの中身
    var cellItems = NSMutableArray()
    // ロード中かどうか
    var isInLoad = false
    // 選択されたセルの列番号
    var selectedRow: Int?
    
    
    
    // ビューのロード完了時に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        // json取得->tableに突っ込む
        makeTableData()
    }
    
    
    // json取得->tableに突っ込む
    func makeTableData() {
        self.isInLoad = true
        var url = NSURL(string: self.urlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json = JSON(data: data)
            //表示させるセル数
            self.cellNum = 2
            // 各セルに情報を突っ込む
            
            for var i = 0; i < self.cellNum; i++ {
                //jsonデータ以上の回数はCellに反映させない(未開発)
                var dt_txt = json["entries"][i]["Post"]["created"]
                println(dt_txt)
                var weatherMain = json["entries"][i]["Post"]["MainTitle"]
                var weatherDescription = json["entries"][i]["User"]["username"]
                var photourl = json["entries"][i]["Post"]["Images"]
                var post_id = json["entries"][i]["Post"]["id"]
                var info = "\(dt_txt), \(weatherMain), \(weatherDescription)"
                println("photourl=")
                println(photourl)
                
                self.cellItems[i] = [info,"\(photourl)","\(post_id)"]
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
    
    // 戻り値を変更
    // セクションの数
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.sectionNum
    }
    // 戻り値を変更
    // 1セクションあたりのセルの行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.cellNum
    }
    // コメントアウトされてるのではずす
    // セルの中身を設定
    // 継承時は書かれてないので、メソッドを追加
    // Segue選択時の挙動
    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 選択されたセルの行数を記録
        self.selectedRow = indexPath.row
        performSegueWithIdentifier("toCellViewController", sender: nil)
    }
    // コメントアウトされてるのではずす
    // CellViewControllerにセルの値を渡す
    // segueで画面遷移するときに呼び出される
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "toCellViewController" {
            // 遷移先のViewContollerにセルの情報を渡す
            let cellVC : PostCellViewController = segue.destinationViewController as! PostCellViewController
            cellVC.info = (cellItems[self.selectedRow!][0] as! String)
            cellVC.photourl = (cellItems[self.selectedRow!][1] as! String)
            cellVC.post_id = (cellItems[self.selectedRow!][2] as! String)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PoststableCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = self.cellItems[indexPath.row][0] as? String
        // Configure the cell...
        
        return cell
    }
    
    
    
    //↓CoreDataを使ったデータの保存処理
    
    @objc(LoadStore)
    class LoadStore: NSManagedObject {
        
        @NSManaged var imageurl:String
        //@NSManaged var post_id:String
    }
    
    @IBAction func favoretsdata(){
        readData()
    }
    
    
    // 読み込み処理（readBtnのアクション）
    func readData() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let favoritesContext: NSManagedObjectContext = appDel.managedObjectContext!
        let memoRequest: NSFetchRequest = NSFetchRequest(entityName: "Posts")
        memoRequest.returnsObjectsAsFaults = false
        var results: NSArray! = favoritesContext.executeFetchRequest(memoRequest, error: nil)
        
        var photo_urls: [NSString] = []
        //var post_ids: [NSString] = []
        
        for data in results {
            photo_urls.append(data.imageurl)
            //post_ids.append(data.post_id)
        }
        
        
        // コンソールに表示
        println(photo_urls)
        println(photo_urls.count)
        //println(post_ids)
    }
    
    
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




////
////  PostsTableViewController.swift
////  SwiftTsukutabitest
////
////  Created by Ryosei Takahashi on 2015/08/26.
////  Copyright (c) 2015年 Ryosei Takahashi. All rights reserved.
////
//
//import UIKit
//
//
//class PostsTableViewController: UIPostsTableViewController {
//    // セクションの数
//    let sectionNum = 1
//    // 1セクションあたりのセルの行数
//    let cellNum = 10
//
//    // 取得するAPI
//    let urlString = "http://api.openweathermap.org/data/2.5/forecast?units=metric&q=Tokyo"
//    // セルの中身
//    var cellItems = NSMutableArray()
//    // ロード中かどうか
//    var isInLoad = false
//    // 選択されたセルの列番号
//    var selectedRow: Int?
//
//
//    // ビューのロード完了時に呼ばれる
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // json取得->tableに突っ込む
//        makeTableData()
//    }
//
//
//    // json取得->tableに突っ込む
//    func makeTableData() {
//        self.isInLoad = true
//        var url = NSURL(string: self.urlString)!
//        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
//            // リソースの取得が終わると、ここに書いた処理が実行される
//            var json = JSON(data: data)
//            // 各セルに情報を突っ込む
//            for var i = 0; i < self.cellNum; i++ {
//                var dt_txt = json["list"][i]["dt_txt"]
//                var weatherMain = json["list"][i]["weather"][0]["main"]
//                var weatherDescription = json["list"][i]["weather"][0]["description"]
//                var info = "\(dt_txt), \(weatherMain), \(weatherDescription)"
//                self.cellItems[i] = info
//            }
//            // ロードが完了したので、falseに
//            self.isInLoad = false
//        })
//        task.resume()
//
//        // 読み込みが終わるまで待機
//        // (ゆる募)
//        // 下の解決策以外に何か方法があればと。。。
//        // jsonの取得に非同期通信を使ってるので、読み込むまで待ってからじゃないと
//        // cellに値が入らない。同期通信使えって話もあるけど今後の拡張を考えてNSURLSession使ってます(^_^;)
//        while isInLoad {
//            usleep(10)
//        }
//    }
//
//    // 戻り値を変更
//    // セクションの数
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return self.sectionNum
//    }
//    // 戻り値を変更
//    // 1セクションあたりのセルの行数
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return self.cellNum
//    }
//    // コメントアウトされてるのではずす
//    // セルの中身を設定
//    // 継承時は書かれてないので、メソッドを追加
//    // Segue選択時の挙動
//    override func tableView(tableView: UITableView?, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // 選択されたセルの行数を記録
//        self.selectedRow = indexPath.row
//        performSegueWithIdentifier("toCellViewController", sender: nil)
//    }
//    // コメントアウトされてるのではずす
//    // CellViewControllerにセルの値を渡す
//    // segueで画面遷移するときに呼び出される
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "toCellViewController" {
//            // 遷移先のViewContollerにセルの情報を渡す
//            let cellVC : CellViewController = segue.destinationViewController as! CellViewController
//            cellVC.info = (cellItems[self.selectedRow!] as! String)
//        }
//    }
//
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//         let cell = tableView.dequeueReusableCellWithIdentifier("PoststableCell", forIndexPath: indexPath) as! UITableViewCell
//
//        cell.textLabel?.text = self.cellItems[indexPath.row] as? String
//        // Configure the cell...
//
//        return cell
//    }
//
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}


/*
override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

// Configure the cell...

return cell
}
*/

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


