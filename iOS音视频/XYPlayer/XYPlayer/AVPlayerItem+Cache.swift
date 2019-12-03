//
//  AVAsset+Cache.swift
//  XYPlayer
//
//  Created by CXY on 2019/8/7.
//  Copyright © 2019 CXY. All rights reserved.
//

import AVFoundation


extension AVPlayerItem {
    
    private static let assetLoaderKey = "XYAssetLoaderKey"
    
    private static let assetCustomScheme = "XYAsset"
    
    private var cachePath: String {
        return objc_getAssociatedObject(self, AVPlayerItem.assetLoaderKey) as! String
    }
    
    private var cacheLoader: XYAssetLoader? {
        return objc_getAssociatedObject(self, AVPlayerItem.assetLoaderKey) as? XYAssetLoader
    }
    
    static func xy_AVPlayerItem(withUrl url: URL) -> AVPlayerItem {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.scheme = assetCustomScheme
        let asset = AVURLAsset(url: components?.url ?? url)
        let item = AVPlayerItem(asset: asset)
        if let loader = item.cacheLoader {
            asset.resourceLoader.setDelegate(loader, queue: .main)
        } else {
            let loader = XYAssetLoader()
            objc_setAssociatedObject(item, AVPlayerItem.assetLoaderKey, loader, .OBJC_ASSOCIATION_RETAIN)
            asset.resourceLoader.setDelegate(loader, queue: .main)
        }
        return item
    }
}
