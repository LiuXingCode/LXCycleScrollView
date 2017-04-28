//
//  LXCycleScrollView.swift
//  LXCycleScrollViewDemo
//
//  Created by 刘行 on 2017/4/27.
//  Copyright © 2017年 刘行. All rights reserved.
//

import UIKit

protocol LXCycleScrollViewDataSource : class {
    func loadImage(_ cycleScrollView: LXCycleScrollView, imageView: UIImageView, imageURL: URL)
}

fileprivate let LXCollectionCellID = "LXCollectionCellID"
fileprivate let LXItemsMultiple : Int = 100

class LXCycleScrollView: UIView {
    
    weak var dataSource : LXCycleScrollViewDataSource?
    
    var cycleInterval : TimeInterval = 3.0
    
    var imageURLs : [URL]? {
        didSet{
            collectionView.reloadData()
            pageControl.numberOfPages = imageURLs?.count ?? 0
            let indexPath = IndexPath(row: (imageURLs?.count ?? 0) * LXItemsMultiple / 2, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            removeCycleTimer()
            addCycleTimer()
        }
    }
    
    var pageNormalColor : UIColor = UIColor.white {
        didSet{
            pageControl.pageIndicatorTintColor = pageNormalColor
        }
    }
    
    var pageSelectColor : UIColor = UIColor.red {
        didSet{
            pageControl.currentPageIndicatorTintColor = pageSelectColor
        }
    }
    
    fileprivate lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.bounds.size
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(LXCycleItemCell.self, forCellWithReuseIdentifier: LXCollectionCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        return collectionView
    }()
    
    fileprivate lazy var pageControl : UIPageControl = {
        let frame = CGRect(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30)
        let pageControl = UIPageControl(frame: frame)
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = self.pageNormalColor
        pageControl.currentPageIndicatorTintColor = self.pageSelectColor
        return pageControl
    }()
    
    fileprivate var cycleTimer : Timer?
    
    fileprivate var isForbidScroll : Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


//MARK:- 设置UI布局
extension LXCycleScrollView {
    
    fileprivate func setupUI() {
        self.addSubview(collectionView)
        self.addSubview(pageControl)
    }
}


//MARK:- 实现UICollectionViewDataSource
extension LXCycleScrollView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imageURLs?.count ?? 0) * LXItemsMultiple;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LXCollectionCellID, for: indexPath) as! LXCycleItemCell
        self.dataSource?.loadImage(self, imageView: cell.imageView, imageURL: imageURLs![indexPath.row % imageURLs!.count])
        return cell;
    }
}

//MARK:- 实现UICollectionViewDelegate
extension LXCycleScrollView : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isForbidScroll else {
            return
        }
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        let currentIndex = Int(offsetX / scrollView.bounds.width)
        pageControl.currentPage = currentIndex % (imageURLs?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        removeCycleTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isForbidScroll = true
        addCycleTimer()
    }
    
}


//MARK:- 私有方法
extension LXCycleScrollView {
    
    fileprivate func addCycleTimer() {
        cycleTimer = Timer(timeInterval: cycleInterval, repeats: true, block: { (_) in
            let offsetX = self.collectionView.contentOffset.x
            var currentIndex = Int(offsetX / self.collectionView.bounds.width)
            if currentIndex >= self.imageURLs!.count * LXItemsMultiple - 1 {
                currentIndex = self.imageURLs!.count * LXItemsMultiple / 2
                self.collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .right, animated: false)
            } else{
                currentIndex = currentIndex + 1
                self.collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .right, animated: true)
            }
            self.pageControl.currentPage = currentIndex % self.imageURLs!.count
        })
        RunLoop.current.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate()
        cycleTimer = nil
    }
    
}


