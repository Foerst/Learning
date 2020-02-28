//
//  ScanResultViewController.swift
//  BarCode
//
//  Created by CXY on 2020/2/28.
//  Copyright © 2020 CXY. All rights reserved.
//

import UIKit

class ScanResultViewController: UIViewController {
    
    var result: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "扫码结果"
        view.addSubview(lb)
        lb.frame = view.bounds
        lb.text = "\(result ?? "无结果")"
    }
    
    private lazy var lb: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textAlignment = .center
        return lb
    }()


}
