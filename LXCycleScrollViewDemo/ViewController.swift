//
//  ViewController.swift
//  LXCycleScrollViewDemo
//
//  Created by 刘行 on 2017/4/27.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    fileprivate lazy var cycleScrollView : LXCycleScrollView = {
        let frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: 200)
        let cycleScrollView = LXCycleScrollView(frame: frame)
        cycleScrollView.dataSource = self
        return cycleScrollView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }

}


extension ViewController {
    
    fileprivate func setupUI() {
        view.addSubview(cycleScrollView)
        let url1 = URL(string: "http://pic1.win4000.com/wallpaper/d/589c304d1be9c.jpg")!
        let url2 = URL(string: "http://www.hdbizhi.com/images/gadc4e.jpg")!
        let url3 = URL(string: "http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/0F/09/ChMkJlauze2IPKICABzBh_ueXY0AAH9JAMQ2qUAHMGf334.jpg")!
        let url4 = URL(string: "http://bizhi.zhuoku.com/2012/04/29/mao/Mao05.jpg")!
        cycleScrollView.imageURLs = [url1, url2, url3, url4]
    }
}

extension ViewController : LXCycleScrollViewDataSource {
    
    func loadImage(_ cycleScrollView: LXCycleScrollView, imageView: UIImageView, imageURL: URL) {
        imageView.kf.setImage(with: imageURL)
    }
}

