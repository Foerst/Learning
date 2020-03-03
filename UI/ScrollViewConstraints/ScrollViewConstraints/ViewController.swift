//
//  ViewController.swift
//  ScrollViewConstraints
//
//  Created by CXY on 2020/3/3.
//  Copyright © 2020 jc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentHolder)
        contentHolder.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            // important
            make.width.equalToSuperview()
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
    
    // MARK: UI
    
    private var contentHolder: UIView = UIView()
    
    private lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    private lazy var greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .black
        return scroll
    }()

}

