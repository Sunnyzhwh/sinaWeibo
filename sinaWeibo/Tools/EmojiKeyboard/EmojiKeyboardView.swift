//
//  EmojiKeyboardView.swift
//  EmojiKeyboard
//
//  Created by Sunny on 2019/11/29.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
private let EmojiViewCellId = "EmojiViewCellId"
/// 自定义表情包键盘
class EmojiKeyboardView: UIView {
    // 选中表情后的闭包
    private var selectedEmoji:(_ em:Emoticon) -> ()
    private lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiLayout())
    private lazy var toolBar = UIToolbar()
    private lazy var packages = EmoticonManager.shared.packages
    init(height: CGFloat, selectedCallback: @escaping (_ em:Emoticon) -> ()) {
        var rect = UIScreen.main.bounds
        rect.size.height = height
        selectedEmoji = selectedCallback
        super.init(frame: rect)
        backgroundColor = UIColor.orange
        setupUI()
        let indexPath = IndexPath(item: 0, section: 1)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private class EmojiLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            let col: CGFloat = 7
            let row: CGFloat = 3
            let w = (collectionView?.bounds.width)! / col
            let margin = ((collectionView?.bounds.height)! - row * w) * 0.5
            itemSize = CGSize(width: w, height: w)
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            sectionInset = UIEdgeInsets(top: margin, left: 0, bottom: margin, right: 0)
            scrollDirection = .horizontal
            collectionView?.isPagingEnabled = true
            collectionView?.bounces = false
            collectionView?.showsHorizontalScrollIndicator = false
        }
    }
}
private extension EmojiKeyboardView {
    func setupUI() {
        addSubview(collectionView)
        addSubview(toolBar)
        
        collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(180)
            make.top.equalTo(self.snp.top)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        }
        toolBar.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(36)
        }
        
        prepareToolbar()
        prepareCollectionView()
    }
    func prepareToolbar() {
        toolBar.tintColor = UIColor.darkGray
        var items = [UIBarButtonItem]()
        var index = 0
        for s in packages {
            print(s.group_icon_name!)
            items.append(UIBarButtonItem(image: UIImage(named: s.group_icon_name!)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(clickItem)))
            index += 1
            items.last?.tag = index
        }
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        toolBar.items = items
    }
    @objc func clickItem(item: UIBarButtonItem) {
        print(item.tag)
        let indexPath = IndexPath(item: 0, section: item.tag - 1)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    func prepareCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: EmojiViewCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}
extension EmojiKeyboardView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiViewCellId, for: indexPath) as! EmojiViewCell
//        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.red : UIColor.green
        cell.emoticon = packages[indexPath.section].emoticons[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let em = packages[indexPath.section].emoticons[indexPath.item]
//        print(em)
        selectedEmoji(em)
    }
    
}
fileprivate class EmojiViewCell: UICollectionViewCell {
    var emoticon: Emoticon? {
        didSet{
            emojiButton.setImage(UIImage(contentsOfFile: emoticon!.imagePath), for: .normal)
            emojiButton.setTitle(emoticon?.emoji, for: .normal)
            if emoticon!.isRemoved {
                emojiButton.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    lazy var emojiButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(emojiButton)
        emojiButton.backgroundColor = UIColor.clear
        emojiButton.frame = bounds.insetBy(dx: 4, dy: 4)
        // 设置emoji大小为表情包图片高度
        emojiButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        emojiButton.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
