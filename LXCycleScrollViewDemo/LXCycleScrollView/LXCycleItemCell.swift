//
//  LXImageContentCell.swift
//  LXCycleScrollViewDemo
//
//  Created by 刘行 on 2017/4/27.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

class LXCycleItemCell: UICollectionViewCell {
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
}
