//
//  ContentViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/31.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit
import WebKit
import Social

class ContentViewController: UIViewController, WKNavigationDelegate {

    let wkWebView = WKWebView()
    //let myURL = "http://siliconhbo.tumblr.com/"
    let backgroundView = UIView()
    let shareView = UIView()
    var article: Article!
    var articleStocks = ArticleStocks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.article.title)
        
        let URL = NSURL(string: self.article.link)
        let URLReq = NSURLRequest(URL: URL!)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showActionMenu")
        self.wkWebView.navigationDelegate = self
        self.wkWebView.frame = self.view.frame
        self.wkWebView.loadRequest(URLReq)
        self.view.addSubview(wkWebView)
        
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.navigationItem.title = "Loading..."
        SVProgressHUD.show()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        self.navigationItem.title = wkWebView.title
        SVProgressHUD.dismiss()
    }
    
// ---------アクションボタン追加(facebook,Twitterのシェアボタンなど)---------//

    func showActionMenu() {
        setBackgroundView()
        setShareView()
        setShareBtn(self.view.frame.width/8, tag: 1, imageName: "facebook_icon")
        setShareBtn(self.view.frame.width/8 * 3, tag: 2, imageName: "twitter_icon")
        setShareBtn(self.view.frame.width/8 * 5, tag: 3, imageName: "safari_icon")
        setShareBtn(self.view.frame.width/8 * 7, tag: 4, imageName: "bookmark_icon")
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            self.shareView.frame.origin = CGPointMake(0, self.view.frame.height - 144)
        })
    }
    
    func setBackgroundView() {
        backgroundView.frame.size = self.view.frame.size
        backgroundView.frame.origin = CGPointMake(0, 0)
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(backgroundView)
        
        let gesture = UITapGestureRecognizer(target: self, action: "tapBackgroundView")
        backgroundView.addGestureRecognizer(gesture)
    }
    
    func setShareView() {
        shareView.frame = CGRectMake(0, self.view.frame.height, self.view.frame.width, 100)
        shareView.backgroundColor = UIColor.whiteColor()
        shareView.layer.cornerRadius = 3
        backgroundView.addSubview(shareView)
    }
    
    func setShareBtn(x: CGFloat, tag: Int, imageName: String){
        let shareBtn = UIButton()
        shareBtn.frame.size = CGSizeMake(60, 60)
        shareBtn.center = CGPointMake(x, 50)
        shareBtn.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        shareBtn.layer.cornerRadius = 3
        shareBtn.tag = tag
        shareBtn.addTarget(self, action: "tapSharebtn:", forControlEvents: UIControlEvents.TouchUpInside)
        shareView.addSubview(shareBtn)
    }
    
    func tapSharebtn(sender: UIButton) {
        if sender.tag == 1 {
            //Facebookに記事をシェア
            let facebookVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookVC.setInitialText(wkWebView.title)
            facebookVC.addURL(wkWebView.URL)
            presentViewController(facebookVC, animated: true, completion: nil)
        } else if sender.tag == 2 {
            //Twitterに記事をシェア
            let twitterVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterVC.setInitialText(wkWebView.title)
            twitterVC.addURL(wkWebView.URL)
            presentViewController(twitterVC, animated: true, completion: nil)
        } else if sender.tag == 3 {
            //Safariで記事を開く
            UIApplication.sharedApplication().openURL(wkWebView.URL!)
        } else if sender.tag == 4 {
            //ブックマークに追加
            self.articleStocks.addArticleStocks(self.article)
            print(self.articleStocks.myArticles)
        }
    }
    
    func tapBackgroundView() {
        backgroundView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
