//
//  ThirdViewController.swift
//  ScrollViewConstraints
//
//  Created by CXY on 2020/3/3.
//  Copyright © 2020 jc. All rights reserved.
//

import UIKit

class ThirdViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func setupUI() {
        // important
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentHolder.translatesAutoresizingMaskIntoConstraints = false
        redView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        
        // 视图、布局等对象的信息，用于VFL中格式字符串替换
        let views: [String : Any] = ["slv": scrollView,
                                     "view": view!,
                                     "contentHolder": contentHolder,
                                     "redView": redView,
                                     "greenView": greenView,
                                     "blueView": blueView,
                                     "topLayoutGuide": topLayoutGuide]
        // 常量信息，用于VFL中格式字符串替换
        let metrics = ["height": 350, "margin": 10]
        
        // H:|-0-[scrollView]-0-|表示间距为0 - 默认父子视图20pt,兄弟视图8pt, 省略0pt
        // "V:|[topLayoutGuide]-10-[slv]|" 表示设置与topLayoutGuide的垂直间距为10pt
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[slv]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[slv]|", options: [], metrics: nil, views: views))
        
        scrollView.addSubview(contentHolder)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentHolder(==slv)]|", options: [], metrics: nil, views: views))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentHolder]|", options: [], metrics: nil, views: views))
        
        contentHolder.addSubview(redView)
        contentHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[redView]-margin-|", options: [], metrics: metrics, views: views))
        
        contentHolder.addSubview(greenView)
        contentHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[greenView]-margin-|", options: [], metrics: metrics, views: views))

        contentHolder.addSubview(blueView)
        contentHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[blueView]-margin-|", options: [], metrics: metrics, views: views))
        
        contentHolder.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[redView(height)]-margin-[greenView(==redView)]-margin-[blueView(==redView)]-margin-|", options: [], metrics: metrics, views: views))
    
    }
    
    
    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        } else {
            // Fallback on earlier versions
        }
    }

}
