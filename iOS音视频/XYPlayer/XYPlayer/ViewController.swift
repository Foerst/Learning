//
//  ViewController.swift
//  XYPlayer
//
//  Created by CXY on 2019/8/7.
//  Copyright © 2019 CXY. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    private var player: AVPlayer?
    
    private var assetLoader = XYAssetLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func play(_ sender: UIButton) {
        let url = URL(string: "http://video.ubtrobot.com/jimu/post/180616131624932685.mp4")!
        let item = AVPlayerItem.xy_AVPlayerItem(withUrl: url)
        
        player = AVPlayer(playerItem: item)
        if #available(iOS 10.0, *) {
            player?.automaticallyWaitsToMinimizeStalling = false
        } else {
            // Fallback on earlier versions
        }
        
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            self.player?.play()
        }
    }
    
}

