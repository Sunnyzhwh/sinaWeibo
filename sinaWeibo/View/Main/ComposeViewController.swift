//
//  ComposeViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/12/2.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
/// 发布微博页面
class ComposeViewController: UIViewController {
    // MARK: 监听点击事件
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @objc private func send() {
        print("send")
        print(textView.submitContext)
    }
    @objc private func choose_add() {
        print("add")
    }
    @objc private func choose_picture() {
        print("picture")
    }
    @objc private func choose_mention() {
        print("mention")
    }
    @objc private func choose_topic() {
        print("topic")
    }
    @objc private func choose_gif() {
        print("gif")
    }
    @objc private func choose_emotion() {
        textView.resignFirstResponder()
        print("emotion")
        // 设置键盘切换
        textView.inputView = (textView.inputView == nil) ? emojiKeyboardView : nil
        textView.becomeFirstResponder()
    }
    
    // MARK: 处理键盘frame变化
    /// 处理键盘frame变化
    @objc private func keyboardChanged(n:Notification){
//        print(n)
        let rect = (n.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        print(rect)
        let duration = (n.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        print(duration)
        var offset:CGFloat = 0
        if rect.origin.y == 812 {
             offset = UIScreen.main.bounds.height - rect.origin.y
        }else{
            offset = UIScreen.main.bounds.height - rect.origin.y - 34
        }
        toolbar.snp.updateConstraints {
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-offset)
        }
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    override func loadView() {
        view = UIView()
        setup()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 添加键盘变化给通知中心
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardChanged),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
    }
    // 注销键盘变化通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    // MARK: 初始化自定义表情包
    var bottomSafe: CGFloat {
        get{
            return view.safeAreaInsets.bottom
        }
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        print(bottomSafe)
    }
    private lazy var toolbar = UIToolbar()
    private lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = UIColor.lightGray
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .onDrag
        return tv
        }()
    private lazy var textHolder = UILabel(title: "分享一些事情", fontSize: 18, color: UIColor.lightGray)
    private lazy var emojiKeyboardView: EmojiKeyboardView = {
        var keyboardView: EmojiKeyboardView?
        if bottomSafe > 0 {
            keyboardView = EmojiKeyboardView(height: cheight) { [weak self] in
                self?.textView.selectedEmoji(em: $0)
            }
        }else {
            keyboardView = EmojiKeyboardView(height: nheight) { [weak self] in
                self?.textView.selectedEmoji(em: $0)
            }
        }
        keyboardView!.backgroundColor = UIColor.white
        return keyboardView!
    }()
}
private extension ComposeViewController {
    func setup() {
        view.backgroundColor = UIColor.white
        prepareNav()
        prepareToolbar()
        prepareTextView()
    }
    func prepareNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: #selector(send))
        
        let titleLabel = UILabel(title: "发微博", fontSize: 15)
        let nameLabel = UILabel(title: UserAccountViewModel.sharedUserAccount.account?.screen_name ?? "",
                                fontSize: 13, color: UIColor.lightGray)
        let view = [titleLabel,nameLabel]
        let titleView = UIStackView(arrangedSubviews: view)
        titleView.axis = .vertical
        titleView.alignment = .center
        titleView.spacing = 3
        navigationItem.titleView = titleView
        
    }
    func prepareToolbar() {
        view.addSubview(toolbar)
        toolbar.backgroundColor = UIColor.white
        toolbar.snp.makeConstraints {
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.bottom.equalTo(view.snp.bottomMargin)
            $0.height.equalTo(36)
        }
        let itemSettings = ["half_compose_icon_picture",
                            "half_compose_icon_mention",
                            "half_compose_icon_topic",
                            "half_compose_icon_gif",
                            "half_compose_icon_emotion",
                            "half_compose_icon_add"]
        var items = [UIBarButtonItem]()
        itemSettings.forEach {
            items.append(UIBarButtonItem(imageName: $0, replace: "half_compose_icon", with: "choose", target: self))
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolbar.items = items
    }
    func prepareTextView() {
        view.addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.equalTo(view.snp.left)
            $0.right.equalTo(view.snp.right)
            $0.top.equalTo(view.snp.topMargin)
            $0.bottom.equalTo(toolbar.snp.top)
        }
        textView.text = "分享一些事情"
        textView.addSubview(textHolder)
        textHolder.snp.makeConstraints {
            $0.top.equalTo(textView.snp.top).offset(8)
            $0.left.equalTo(textView.snp.left).offset(4.4)
        }
    }
}