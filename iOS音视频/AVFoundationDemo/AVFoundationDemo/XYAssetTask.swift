//
//  XYAssetTask.swift
//  AVFoundationDemo
//
//  Created by CXY on 2019/2/15.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

import UIKit

class XYAssetTask: Operation {
    var range: NSRange?
    var loadRequest: AVAssetResourceLoadingRequest?
    var assetManager: XYAssetManager?
    
    var taskCompleted: ((XYAssetTask, NSError)->Void)?
    
    
    override func main() {
        
    }
}
