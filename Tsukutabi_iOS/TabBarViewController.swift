//
//  TabBarViewController.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/09/06.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //指定する色を定義
        let blue = UIColor(red: 11.0 / 255, green: 78.0 / 255, blue: 160.0 / 255, alpha: 1.0)
        let black = UIColor(red: 48.0 / 255, green: 48.0 / 255, blue: 47.0 / 255, alpha: 1.0)
        let white = UIColor.whiteColor()
        
        //Tab Bar Itemに設定する画像を用意
        let homeImage      = makeOriginalImage("Home.png")
        let home_selectImage = makeOriginalImage("Home_select.png")
        let favoriteImage  = makeOriginalImage("Like.png")
        let favorite_selectImage = makeOriginalImage("Like_select.png")
        let postImage      = makeOriginalImage("Edit.png")
        let post_selectImage = makeOriginalImage("Edit_select.png")
        let userImage      = makeOriginalImage("User.png")
        let user_selectImage = makeOriginalImage("User_select.png")
        
        //Tab Barの背景色を設定
        //UITabBar.appearance().barTintColor = blue
        //UITabBar.appearance().translucent = false // <--曇りガラス効果をOFFにするためArticleViewの高さが変わる
        
        //TabBarControllerと紐付いているView Controllerを取得
        let firstViewController = self.viewControllers![0] as! UIViewController
        let secondViewController = self.viewControllers![1] as! UIViewController
        let thirdViewController = self.viewControllers![2] as! UIViewController
        let fourthViewController = self.viewControllers![3] as! UIViewController
        
        //それぞれのView ControllerのTab Bar Itemに用意した画像を設定
        firstViewController.tabBarItem = UITabBarItem(title: "Home", image: homeImage, selectedImage: home_selectImage)
        secondViewController.tabBarItem = UITabBarItem(title: "Favorite", image: favoriteImage, selectedImage: favorite_selectImage)
        thirdViewController.tabBarItem = UITabBarItem(title: "投稿", image: postImage, selectedImage: post_selectImage)
        fourthViewController.tabBarItem = UITabBarItem(title: "My Page", image: userImage, selectedImage: user_selectImage)
        
        //特定のキーを指定した辞書型を用意
        let normalAttributes: Dictionary! = [NSForegroundColorAttributeName: black]
        let selectedAttributes: Dictionary! = [NSForegroundColorAttributeName: white]
        
        //Tab Bar Itemのタイトルカラーを設定
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
    }
    
    func makeOriginalImage(name: String) -> UIImage {
        let image = UIImage(named: name)!
        let originalImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        return originalImage
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
