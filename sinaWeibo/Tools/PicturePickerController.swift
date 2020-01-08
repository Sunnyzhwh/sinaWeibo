//
//  PicturePickerController.swift
//  sinaWeibo
//
//  Created by Sunny on 2020/1/4.
//  Copyright © 2020 Sunny. All rights reserved.
//

import UIKit

private let PicturePickerID = "PicturePickerCellID"
private let PicturePickerMaxCount = 4

class PicturePickerController: UICollectionViewController, PicturePickerCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var pictures = [UIImage]()
    private var selectedIndex = 0
    init() {
        super.init(collectionViewLayout: PicturePickerLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(PicturePickerCell.self, forCellWithReuseIdentifier: PicturePickerID)

        // Do any additional setup after loading the view.
    }
    // MARK: 照片选择器布局
    private class PicturePickerLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            
            let count: CGFloat = 4
            let margin = UIScreen.main.scale * 4
            let width = (collectionView!.bounds.width - (count + 1) * margin) / count
            itemSize = CGSize(width: width, height: width)
            sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
            minimumLineSpacing = margin
            minimumInteritemSpacing = margin
        }
    }
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pictures.count + (pictures.count == PicturePickerMaxCount ? 0 : 1)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicturePickerID, for: indexPath) as! PicturePickerCell
    
        // Configure the cell
        cell.image = (indexPath.item < pictures.count) ? pictures[indexPath.item] : nil
        cell.pictureDelegate = self
        return cell
    }
    // MARK: 定义代理方法
    fileprivate func picturePickerCellDidAdd(cell: PicturePickerCell) {
        print("add")
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            print("无法访问照片库")
            return
        }
        // 记录当前用户选中的照片索引
        selectedIndex = collectionView.indexPath(for: cell)!.item
        let picker = UIImagePickerController()
        picker.delegate = self
        //适合用于头像选择
//        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    fileprivate func picturePickerCellDidRemove(cell: PicturePickerCell) {
        print("remove")
        let indexPath = collectionView.indexPath(for: cell)!
        if indexPath.item >= pictures.count {return}
        pictures.remove(at: indexPath.item)
        collectionView.reloadData()
        //TODO: 后续处理越界问题
//        collectionView.deleteItems(at: [indexPath])
    }
    /// 一旦实现代理方法，必须自己dismiss
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info)
        // 释放控制器
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let scaleImage = image.scaleToWidth(width: 600)
        // 判断当前选中的索引是否超出数组上限
        if selectedIndex >= pictures.count {
            pictures.append(scaleImage)
        }else {
            pictures[selectedIndex] = scaleImage
        }
//        pictures.append(image)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }

}
@objc
private protocol PicturePickerCellDelegate: NSObjectProtocol {
    @objc optional func picturePickerCellDidAdd(cell: PicturePickerCell)
    @objc optional func picturePickerCellDidRemove(cell: PicturePickerCell)
}

private class PicturePickerCell: UICollectionViewCell {
    weak var pictureDelegate: PicturePickerCellDelegate?
    var image: UIImage? {
        didSet{
            addButton.setImage(image ?? UIImage(named: "compose_pic_add"), for: .normal)
            // 隐藏删除按钮
            removeButton.isHidden = (image == nil)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func addPicture() {
//        print("add")
        pictureDelegate?.picturePickerCellDidAdd?(cell: self)
    }
    @objc func removePicture() {
//        print("remove")
        pictureDelegate?.picturePickerCellDidRemove?(cell: self)
    }
    private func setupUI() {
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        addButton.frame = bounds
        removeButton.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        addButton.addTarget(self, action: #selector(addPicture), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePicture), for: .touchUpInside)
        addButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private lazy var addButton: UIButton = UIButton(imageName: "compose_pic_add", backgroundImageName: nil)
    private lazy var removeButton: UIButton = UIButton(imageName: "compose_photo_close", backgroundImageName: nil)
}
