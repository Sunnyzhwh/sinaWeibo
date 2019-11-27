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
    // MARK: 监听方法KVO 箭头旋转标志
    private var rotatoFlag = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y > 0 {
            return
        }
        if frame.origin.y < WBRefreshControlOffset, !rotatoFlag {
            print("反过来")
            rotatoFlag = true
        }else if frame.origin.y >= WBRefreshControlOffset, rotatoFlag{
            print("转过去")
            rotatoFlag = false
        }
        print(frame)
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
        addSubview(refreshView)
        bringSubviewToFront(refreshView)
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
    class func refreshView() -> WBRefreshView {
        let nib = UINib(nibName: "WBRefreshView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! WBRefreshView
    }
}
