//
//  ContentViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/31.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var myWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let myURL = NSURL(string: "http://siliconhbo.tumblr.com/")
        
        let myURLReq = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLReq)
        
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
