//
//  ViewController.swift
//  ScrollViewConstraints
//
//  Created by CXY on 2020/3/3.
//  Copyright © 2020 jc. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentHolder)
        contentHolder.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            // important
            make.width.equalToSuperview()
            // make.width.equalTo(view)
        }
        
        contentHolder.addSubview(redView)
        redView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(350)
        }
        
        contentHolder.addSubview(greenView)
        greenView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(redView)
            make.top.equalTo(redView.snp.bottom).offset(10)
        }

        contentHolder.addSubview(blueView)
        blueView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(redView)
            make.top.equalTo(greenView.snp.bottom).offset(10)
        }

        // important
        contentHolder.snp.makeConstraints { (make) in
            make.bottom.equalTo(blueView).offset(10)
        }
    }

}

