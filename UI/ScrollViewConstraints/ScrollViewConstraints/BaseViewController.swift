//
//  BaseViewController.swift
//  ScrollViewConstraints
//
//  Created by CXY on 2020/3/3.
//  Copyright © 2020 jc. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
    }
    
    // MARK: UI
     
    var contentHolder: UIView = UIView()
     
    lazy var redView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
     
    lazy var greenView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
     
    lazy var blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
     
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .black
        return scroll
    }()
}
