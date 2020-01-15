//
//  PhotoBrowserViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2020/1/15.
//  Copyright © 2020年 Sunny. All rights reserved.
//

import UIKit
private let PhotoBrowserCellId = "PhotoBrowserCellId"
/// 照片浏览器
class PhotoBrowserViewController: UIViewController {
    
    private var urls: [URL]
    private var currentIndexPath: IndexPath
    init(currentIndexPath: IndexPath, urls: [URL]) {
        self.currentIndexPath = currentIndexPath
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserViewLayout())
    
    private class PhotoBrowserViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            itemSize = collectionView!.bounds.size
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
    
    private lazy var pageControll: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = urls.count
        pc.backgroundColor = UIColor.darkGray.withAlphaComponent(0.0)
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPageIndicatorTintColor = UIColor.orange
        
        return pc
    }()
    override func loadView() {
        let rect = UIScreen.main.bounds
        view = UIView(frame: rect)
        setupUI()
        prepareCollectionView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageControll.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.bottom).multipliedBy(0.97)
            make.width.equalTo(20 * urls.count)
            make.height.equalTo(20)
        }
        pageControll.layer.cornerRadius = 10
        pageControll.layer.masksToBounds = true
    }

}
extension PhotoBrowserViewController {
    func setupUI(){
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.addSubview(pageControll)
    }
    func prepareCollectionView() {
        // 注册cell
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCellId)
        // 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
}
extension PhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate, PhotoBrowserDelegate{
    @objc func tapOne(cell: PhotoCollectionViewCell) {
//        print("tap1")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func longPress(cell: PhotoCollectionViewCell) {
        print("long")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCellId, for: indexPath) as! PhotoCollectionViewCell
        cell.imageURL = urls[indexPath.item]
        cell.gestureDelegate = self
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
        pageControll.currentPage = page
    }
    
}
