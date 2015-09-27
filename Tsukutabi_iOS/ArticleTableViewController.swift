//
//  ArticleTableViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/27.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

@objc protocol ArticleTableViewControllerDelegate {
    func didSelectTableViewCell(article: Article)
    
}

class ArticleTableViewController: UITableViewController, NSXMLParserDelegate {
    
    weak var customDelegate: ArticleTableViewControllerDelegate?
    
    var titlesArray : [String] = ["Hello Slicon Valley!!", "Golden Bridge!!", "Kim White", "Charles Gray", "Timothy Jones", "Sarah Underwood", "William Pearl", "Juan Rodriguez", "Anna Hunt", "Marie Turner", "George Porter", "Zachary Hecker", "David Fletcher"]
    
    var photoNameArray : [String] = ["woman5.jpg", "man1.jpg", "woman1.jpg", "man2.jpg", "man3.jpg", "woman2.jpg", "man4.jpg", "man5.jpg", "woman3.jpg", "woman4.jpg", "man6.jpg", "man7.jpg", "man8.jpg"]
    
    var backgroundArray : [String] = ["silicon_valley.jpg", "back2.jpg", "back3.jpg", "back4.jpg", "back5.jpg",
                                      "back6.jpg", "back7.jpg", "back8.jpg", "back9.jpg", "back10.jpg",
                                      "back11.jpg", "back12.jpg", "back13.jpg"]
    
    //サイトURL
//    let wiredURL = "http://wired.jp/rssfeeder/"
//    let shikiURL =  "http://www.100shiki.com/feed"
//    let cinraURL =   "http://www.cinra.net/rss-all.xml"
//    var isInLoad = false
//    let urlString = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://rss.dailynews.yahoo.co.jp/fc/computer/rss.xml&num=10"
//    
    var elementName = ""
    // 複数の記事を保存するための配列
    var articles:Array<Article> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SVProgressHUD.show()
        
        self.tableView.registerNib(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        
        self.tableView.addPullToRefresh({ [weak self] in
            // refresh code
            
            self?.tableView.reloadData()
            self?.tableView.stopPullToRefresh()
        })
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 記事の数だけセルを生成
        return self.articles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : ArticleTableViewCell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell") as! ArticleTableViewCell
        
        // Configure the cell...
        //cell.titleLabel.text = titlesArray[indexPath.row]
        cell.photoImageView.image = UIImage(named: photoNameArray[indexPath.row])   // <-- RSSの記事の数とダミー写真の数が違うためエラーが起こる
        cell.backImageView.image = UIImage(named: backgroundArray[indexPath.row])
        let article = self.articles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.date.text = conversionDateFormat(article.date)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = articles[indexPath.row]
        self.customDelegate?.didSelectTableViewCell(article)
    }
    
    
// ------------XMLの処理-----------------------------------//
    
    //URLのデータから、リクエストを送ることができるデータに変換
    func loadRSS(siteURL: String) {
        if let url = NSURL(string: siteURL) {
            let request = NSURLRequest(URL: url)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                // 取得したdataを使って行いたい処理を記述
                let parser = NSXMLParser(data: data!)
                parser.delegate = self
                parser.parse()
            })
            task.resume()
        }
    }
    
    //loadRSSメソッドで、取得したXMLタグが、読み込まれたタイミングで呼ばれるデリゲートメソッド
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.elementName = elementName
        if self.elementName == "item" {
            let article = Article()
            self.articles.append(article)
        }
    }
    
    //解析がスタートしてタグ以外のテキストを読み込んだタイミングで呼ばれるデリゲートメソッド
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let lastArticle = self.articles.last
        if self.elementName == "title" {
            lastArticle?.title += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "user_icon" {
            lastArticle?.user_icon += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "pubDate" {
            lastArticle?.date += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        } else if self.elementName == "link" {
            lastArticle?.link += string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    
    // 解析が終了したタイミングで呼ばれるデリゲートメソッド
    func parserDidEndDocument(parser: NSXMLParser) {
        
        // このメソッドを使用することでメインキューにアクセスすることが可能
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()     // <----  TableViewというUI部品の更新はメインキューでしか行えない
        })
    }
    
// -------------JSONの処理・取得 -------------------------------------//
//    func loadJSON() {
//        self.isInLoad = true
//        var url = NSURL(string: self.urlString)!
//        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
//            //リソースの処理が終わると、ここに書いた処理が実行される
//            var json = JSON(data: data)
//            
//            //各セルに情報を突っ込む
//            for var i = 0; i < self.articles.count; i++ {
//                var entries = json["responseData"]["feed"]["entries"][i]
//            }
//        })
//    }
    
    func conversionDateFormat(dateString: String) -> String {
        let inputFormatter = NSDateFormatter()
        inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date: NSDate! = inputFormatter.dateFromString(dateString)
        
        let outputFormatter = NSDateFormatter()
        outputFormatter.dateFormat = "yyy/MM/dd HH:mm"
        let outputDateString = outputFormatter.stringFromDate(date)
        return outputDateString
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}