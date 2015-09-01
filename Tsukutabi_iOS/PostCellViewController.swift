//
//  PostCellViewController.swift
//  SwiftTsukutabitest
//
//  Created by Ryosei Takahashi on 2015/08/26.
//  Copyright (c) 2015年 Ryosei Takahashi. All rights reserved.
//

import UIKit
//Coredataのインポート
import CoreData

class PostCellViewController: UIViewController , UITextFieldDelegate, NSURLSessionTaskDelegate{
    var pjson:NSData!
    // 画面遷移時に渡される天気情報
    var info : String?
    var photourl : String = ""
    var post_id : String?
    // Label
    @IBOutlet weak var myLabel: UILabel!
    // 取得するAPI
    var urlString = "http://realvoicenext.sakura.ne.jp/cakephp/posts/viewjson/"
    // ロード中かどうか
    var isInLoad = false
    
    //練習用url
    var photo_url = ""
    
    //投稿の中に含まれるurl(写真)の数
    var Image_urls = [""]
    //投稿写真を表示するurl
    var Image_url = ""
    
    
    
    
    
    func into_Image_urls(){
        //ここで変数(photourl)を,で分けて格納する
        println(photourl)
        let separators = NSCharacterSet(charactersInString: " ,")
        //        var fullName: String = "Last, First Middle";
        var photourls = photourl.componentsSeparatedByCharactersInSet(separators)
        println(photourls.count)
        println(photourls[0])
        
        for var nowphoto = 0; nowphoto < photourls.count; nowphoto++ {
            Image_urls.append("http://realvoicenext.sakura.ne.jp/cakephp/img/\(photourls[nowphoto])")
            getImages(nowphoto)
        }
        println(Image_urls[1])
    }
    
    
    func getImages(nowphoto: Int){
        
        //0番目は空なので、返す
        if(nowphoto == 0){
            return
        }
        //渡ったurlを元に、ImageViewに写真を表示する実装
        let url = NSURL(string: "\(Image_urls[nowphoto])");
        var err: NSError?;
        var imageData :NSData = NSData(contentsOfURL: url!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!;
        var img = UIImage(data:imageData);
        
        //それをselfのUIViewへ追加する場合は、
        //UIImageViewに追加してからselfへaddSubviewする
        let iv:UIImageView = UIImageView(image:img);
        iv.frame = CGRectMake(0, 0, 260, 260);
        self.view.addSubview(iv);
        
        // 画像の表示する座標を指定する.
        var image_y = 260*nowphoto+40 //引数で渡ってきた番号分座標位置をずらす演算
        iv.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(image_y))
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //写真情報を取得し、urlを配列に入れる処理
        into_Image_urls()
        
        // 天気情報を突っ込む
        myLabel.text = info
        urlString = "\(urlString)\(post_id)"
        
        
        photo_url = "\(photourl)"
        println(photo_url)
        
        //JSONデータを作って格納
        //makeJSONURL()
        // UITextFieldを作成する.
        let myTextField: UITextField = UITextField(frame: CGRectMake(0,0,200,30))
        
        // 表示する文字を代入する.
        myTextField.text = ""
        
        // Delegateを設定する.
        myTextField.delegate = self
        
        // 枠を表示する.
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
        
        // UITextFieldの表示する位置を設定する.
        myTextField.layer.position = CGPoint(x:self.view.bounds.width/2,y:100);
        
        // Viewに追加する.
        self.view.addSubview(myTextField)
        
        
    }
    
    
    /*
    UITextFieldが編集された直後に呼ばれる.
    */
    func textFieldDidBeginEditing(textField: UITextField){
        println("textFieldDidBeginEditing:" + textField.text)
    }
    
    /*
    UITextFieldが編集終了する直前に呼ばれる.
    */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        println("textFieldShouldEndEditing:" + textField.text)
        
        // まずPOSTで送信したい情報をセット。
        let str = "text=\(textField.text)"
        let strData = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        let url: NSURL = NSURL(string: "送信したいサイトのPOST URL")!
        
        var request = NSMutableURLRequest(URL: url)
        
        // この下二行を見つけるのに、少々てこずりました。
        request.HTTPMethod = "POST"
        request.HTTPBody = strData
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        var dic = NSJSONSerialization.JSONObjectWithData(data!, options:nil, error: nil) as! NSDictionary
        
        return true
    }
    
    /*
    改行ボタンが押された際に呼ばれる.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //JSONで、つく旅の情報を取得
    func makeJSONURL(){
        //JSONデータを作る処理
        self.isInLoad = true
        var url = NSURL(string: self.urlString)!
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: {data, response, error in
            // リソースの取得が終わると、ここに書いた処理が実行される
            var json = JSON(data: data)
            
            // 情報を突っ込む
            
            var dt_txt = json["Post"]["Images"]
            println(dt_txt)
            
            self.Image_url = "http://realvoicenext.sakura.ne.jp/cakephp/img/\(dt_txt)"
            println(self.Image_url)
            
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
    
    
    //データのお気に入り追加
    @IBAction func add(){
        writeData()
    }
    
    
    //↓CoreDataを使ったデータの保存処理
    
    @objc(MemoStore)
    class MemoStore: NSManagedObject {
        
        @NSManaged var imageurl:String
        //@NSManaged var post_id:String
    }
    
    
    
    // 書き込み処理（writeBtnのアクション）
    func writeData() {
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let favoritesContext: NSManagedObjectContext = appDel.managedObjectContext!
        let favoritesEntity: NSEntityDescription! = NSEntityDescription.entityForName("Posts", inManagedObjectContext: favoritesContext)
        var newData = MemoStore(entity: favoritesEntity, insertIntoManagedObjectContext: favoritesContext)
        newData.imageurl = photo_url
        //newData.post_id = post_id!
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
        
        
        //        func save()
        //        {
        //            var error : NSError?
        //            if(MemoStore().save(&error) ) {
        //                println(error?.localizedDescription)
        //            }
        //        }
        
        // コンソールに表示
        println(photo_urls)
        println(photo_urls.count)
        //println(post_ids)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}



////
////  PostCellViewController.swift
////  SwiftTsukutabitest
////
////  Created by Ryosei Takahashi on 2015/08/26.
////  Copyright (c) 2015年 Ryosei Takahashi. All rights reserved.
////
//
//import UIKit
//
//class PostCellViewController: UIViewController {
//    // 画面遷移時に渡される天気情報
//    var info : String?
//    // Label
//    @IBOutlet weak var myLabel: UILabel!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // 天気情報を突っ込む
//             myLabel.text = info
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
