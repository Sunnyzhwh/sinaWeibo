//
//  WBRefreshControl.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/15.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
private let WBRefreshControlOffset: CGFloat = -60
class WBRefreshControl: UIRefreshControl {
    override func beginRefreshing() {
        super.beginRefreshing()
        refreshView.beginAnimation()
    }
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.endAnimation()
    }
    // MARK: 监听方法KVO 箭头旋转标志
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        if isRefreshing {
            refreshView.beginAnimation()
            return
        }
        if frame.origin.y < WBRefreshControlOffset, !refreshView.rotateFlag {
            print("反过来")
            refreshView.rotateFlag = true
        }else if frame.origin.y >= WBRefreshControlOffset, refreshView.rotateFlag{
            print("转过去")
            refreshView.rotateFlag = false
        }
//        print(frame)
    }
    override init() {
        super.init()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
//        fatalError("init(coder:) has not been implemented")
    }
    private lazy var refreshView = WBRefreshView.refreshView()
    private func setupUI() {
        tintColor = UIColor.clear
        addSubview(refreshView)
        /// 自动布局 - 从NIB加载的控件需要制定大小约束
        refreshView.snp.makeConstraints { (make) in
//            make.centerX.equalTo(self.snp.centerX)
//            make.centerY.equalTo(self.snp.centerY)
            make.center.equalTo(self.snp.center)
            make.size.equalTo(refreshView.bounds.size)
        }
        // KVO 监听 - 主队列，当主线程有任务时，就不调度队列中的任务执行
        DispatchQueue.main.async {
            self.addObserver(self, forKeyPath: "frame", options: [], context: nil)
        }
        
    }
    deinit {
        self.removeObserver(self, forKeyPath: "frame")
    }
}
class WBRefreshView: UIView {
    @IBOutlet weak var loadingView: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipIconView: UIImageView!
    fileprivate var rotateFlag = false {
        didSet{
            rotatoTipIcon()
        }
    }
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! WBRefreshView
    }
    fileprivate func rotatoTipIcon() {
        if rotateFlag {
            UIView.animate(withDuration: 0.25) {
                self.tipIconView.transform = CGAffineTransform(rotationAngle: CGFloat.pi - 0.0000001)
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.tipIconView.transform = CGAffineTransform.identity
            }
        }
    }
    fileprivate func beginAnimation() {
        tipView.isHidden = true
        let key = "transform.rotation"
        if loadingView.layer.animation(forKey: key) != nil {
            return
        }
        print("动画已经加载")
        let animation = CABasicAnimation(keyPath: key)
        animation.toValue = 2 * CGFloat.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 2
        animation.isRemovedOnCompletion = false
        loadingView.layer.add(animation, forKey: key)
    }
    fileprivate func endAnimation() {
        tipView.isHidden = false
        loadingView.layer.removeAllAnimations()
    }
}
