//
//  ArticleStocks.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/09/06.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class ArticleStocks: NSObject {
    var myArticles: Array<Article> = []
    
    func addArticleStocks(article: Article) {
        self.myArticles.insert(article, atIndex: 0)
    }
}
