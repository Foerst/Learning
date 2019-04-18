//
//  ViewController.swift
//  VideoToolbox_Code
//
//  Created by CXY on 2018/12/25.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func hardEncodeH264(_ sender: UIButton) {
        navigationController?.pushViewController(EncodeH264ViewController(), animated: true)
    }
    

}

