//
//  NewfeatureViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/9.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import SnapKit
private let WBNewfeatureViewCellId = "WBNewfeatureViewCellId"
private let WBWBNewfeatureImageCount = 4
class NewfeatureViewController: UICollectionViewController {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pageControll: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = 4
        pc.backgroundColor = UIColor.darkGray.withAlphaComponent(0.0)
        pc.pageIndicatorTintColor = UIColor.lightGray
        pc.currentPageIndicatorTintColor = UIColor.orange

        return pc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(NewFeatureCell.self, forCellWithReuseIdentifier: WBNewfeatureViewCellId)
        collectionView.addSubview(pageControll)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        collectionView.bringSubviewToFront(pageControll)
        pageControll.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.bottom).multipliedBy(0.95)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        pageControll.layer.cornerRadius = 10
        pageControll.layer.masksToBounds = true
    }

    // MARK: 设置状态栏的隐藏
    override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return WBWBNewfeatureImageCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBNewfeatureViewCellId, for: indexPath) as! NewFeatureCell
    
        // Configure the cell
        cell.imageIndex = indexPath.item
        return cell
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page != WBWBNewfeatureImageCount - 1 { return }
        let cell = collectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! NewFeatureCell
        cell.showButtonAnimated()
        
        
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + scrollView.bounds.width / 2) / scrollView.bounds.width)
        pageControll.currentPage = page
    }
}

// MARK: 新特性cell
private class NewFeatureCell: UICollectionViewCell {
    
    fileprivate var imageIndex: Int = 0 {
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIndex + 1)")
            startButton.isHidden = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func startButtonClicked() {
        print("start")
        NotificationCenter.default.post(name: WBSwitchRootViewControllerNotification, object: nil)
    }
    private func setUI() {
        addSubview(iconView)
        addSubview(startButton)
        iconView.frame = bounds
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.bottom).multipliedBy(0.7)
        }
        startButton.isUserInteractionEnabled = false
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }

    fileprivate func showButtonAnimated() {
        startButton.isHidden = false
        startButton.transform = __CGAffineTransformMake(0, 0, 0, 0, 0, 0)
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        self.startButton.transform = CGAffineTransform.identity
        }) { (_) in
            print("按钮动画完成ok")
            self.startButton.isUserInteractionEnabled = true
        }
    }
    private lazy var iconView = UIImageView()
    private lazy var startButton = UIButton(title: "开始体验", color: UIColor.white, backgroundImageName: "new_feature_finish_button")
}
