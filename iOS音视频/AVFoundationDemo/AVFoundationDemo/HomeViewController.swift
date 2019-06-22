//
//  ViewController.swift
//  AVFoundationDemo
//
//  Created by CXY on 2019/1/26.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
    private lazy var resourceLoaderManager = VIResourceLoaderManager()
    
    private lazy var resourceLoaderDelegate = XYAssetLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)
        title = "离线缓存方案"
    }

    @IBAction func aVPlayerCacheSupport(_ sender: UIButton) {
        do {
            let path = "http://10.10.62.193:3000/video?name=123"
            let url = URL(string: path)!
            let item = try AVPlayerItem.mc_playerItem(withRemoteURL: url)
            let player = AVPlayer(playerItem: item)
            player.automaticallyWaitsToMinimizeStalling = false
            let playerController = AVPlayerViewController()
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        } catch  {
            print(error)
        }
    }

    
    @IBAction func DVAssetLoader(_ sender: UIButton) {
        navigationController?.pushViewController(DVViewController(), animated: true)
    }
    
    @IBAction func custom(_ sender: UIButton) {
        // "cxy://video.ubtrobot.com/jimu/post/180616131624932685.mp4"
        let url = URL(string: "cxy://video.ubtrobot.com/jimu/post/180616131624932685.mp4")!
        let urlAsset = AVURLAsset(url: url)
        urlAsset.resourceLoader.setDelegate(resourceLoaderDelegate, queue: DispatchQueue.main)
        let playerItem = AVPlayerItem(asset: urlAsset)
        let player = AVPlayer(playerItem: playerItem)
        player.automaticallyWaitsToMinimizeStalling = false
        // support only AVQueuePlayer
//        player.actionAtItemEnd = .advance
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func playMultVideo(_ sender: UIButton) {
        navigationController?.pushViewController(VideoListViewController(), animated: true)
    }
    
    
}

