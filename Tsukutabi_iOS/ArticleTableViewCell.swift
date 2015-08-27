//
//  ArticleTableViewCell.swift
//  Tsukutabi_iOS
//
//  Created by Black/Jack on 2015/08/27.
//  Copyright (c) 2015年 Black/Jack. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        photoImageView.layer.cornerRadius = photoImageView.frame.width / 2
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor(red: 125, green: 125, blue: 125, alpha: 1.0).CGColor
        photoImageView.layer.masksToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
