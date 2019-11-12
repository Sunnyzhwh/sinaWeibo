//
//  WelcomeViewController.swift
//  sinaWeibo
//
//  Created by Sunny on 2019/11/10.
//  Copyright © 2019年 Sunny. All rights reserved.
//

import UIKit
import Kingfisher
class WelcomeViewController: UIViewController {
    
    override func loadView() {
        view = backImageView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let processor = DownsamplingImageProcessor(size: iconView.frame.size)
            >> RoundCornerImageProcessor(cornerRadius: 20)
        iconView.kf.setImage(with: UserAccountViewModel.sharedUserAccount.avatarUrl, placeholder: UIImage(named: "placeholderImage"),
                             options: [
                                .processor(processor),
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
         使用自动布局开发，有个原则
         所有使用约束设置的控件，不要再设置frame
         原因：自动布局系统会根据设置的约束，自动计算控件的frame
         在layoutsubviews中设置frame
         主动修改frame，会引起自动布局系统计算错误
         工作原理：当有一个运行循环启动，自动布局系统会收集所有的约束变化
         在运行循环结束前，调用layoutSubviews 统一设置frame
         如果希望某些约束提前更新，使用layoutifneeded，让自动布局系统提前更新当前收集到的约束变化
         */
        iconView.snp.updateConstraints { (update) in
            update.bottom.equalTo(view.snp.bottom).offset(-view.bounds.height + 200)
        }
        welcomeLabel.alpha = 0
        UIView.animate(withDuration: 1.2,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
                        self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.welcomeLabel.alpha = 1
            }) { (_) in
                print("用户头像动画完成ok！")
                // 不推荐的写法
//                UIApplication.shared.keyWindow?.rootViewController = MainViewController()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    NotificationCenter.default.post(name: WBSwitchRootViewControllerNotification, object: nil)
                }
            }
        }
    }
    private lazy var backImageView: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_default_big"))
        iv.layer.cornerRadius = 45
        iv.layer.masksToBounds = true
        return iv
    }()
    private lazy var welcomeLabel: UILabel = UILabel(title: "欢迎归来", fontSize: 18)
}
extension WelcomeViewController {
    private func setupUI() {
        view.addSubview(iconView)
        view.addSubview(welcomeLabel)
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
            make.size.equalTo(90)
        }
        welcomeLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(iconView.snp.bottom).offset(20)
        }
    }
}
