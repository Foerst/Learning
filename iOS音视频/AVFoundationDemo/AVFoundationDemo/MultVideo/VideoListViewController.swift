//
//  VideoListViewController.swift
//  AVFoundationDemo
//
//  Created by CXY on 2019/2/18.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

import UIKit
import AVFoundation

class VideoListViewController: UIViewController {
    
    private lazy var playerView0: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var playerView1: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var playerView2: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var playerView3: UIView = {
        let view = UIView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(playerView0)
        playerView0.frame = CGRect(x: 50, y: 100, width: 200, height: 100)
        view.addSubview(playerView1)
        playerView1.frame = CGRect(x: 50, y: 210, width: 200, height: 100)
        view.addSubview(playerView2)
        playerView2.frame = CGRect(x: 50, y: 320, width: 200, height: 100)
        view.addSubview(playerView3)
        playerView3.frame = CGRect(x: 50, y: 430, width: 200, height: 100)
        
        DispatchQueue.global().async {
            self.readData(path: "20161231114549.mp4", displayView: self.playerView0)
        }
        DispatchQueue.global().async {
            self.readData(path: "20171022083440638.mp4", displayView: self.playerView1)
        }
        DispatchQueue.global().async {
            self.readData(path: "20170610222420423.mp4", displayView: self.playerView2)
        }
        DispatchQueue.global().async {
            self.readData(path: "20171022092126910.mp4", displayView: self.playerView3)
        }
    }
    

    private func readData(path: String, displayView: UIView) {
        // AVAssetReader必须本地资源
        // Error Domain=AVFoundationErrorDomain Code=-11838 "Cannot initialize an instance of AVAssetReader with an asset at non-local URL 'http://localhost:3000/video?name=123'" UserInfo={NSDebugDescription=Cannot initialize an instance of AVAssetReader with an asset at non-local URL 'http://localhost:3000/video?name=123', NSLocalizedDescription=Operation Stopped, NSLocalizedFailureReason=The operation is not supported for this media.}
//        let url = URL(string: "http://localhost:3000/video?name=123")!
        guard let url = Bundle.main.url(forResource: path, withExtension: nil) else {
            return
        }
        let asset = AVURLAsset(url: url)
        
        do {
            let assetReader = try AVAssetReader(asset: asset)
            let videoTracks = asset.tracks(withMediaType: .video)
            if videoTracks.count <= 0 {
                return
            }
            let videoTrack = videoTracks.first!
            let videoReaderTrackOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA])
            assetReader.add(videoReaderTrackOutput)
            assetReader.startReading()
            while assetReader.status == .reading && videoTrack.nominalFrameRate > 0 {
                if let sampleBuffer = videoReaderTrackOutput.copyNextSampleBuffer() {
                    if let cgImage = imageFromSampleBuffer(sampleBuffer, rotation: orientationFromAVAssetTrack(videoTrack)) {
                        DispatchQueue.main.async {
                            displayView.layer.contents = cgImage
                        }
                    }
                    //根据需要休眠一段时间, 视频播放的时候没一帧都是有间隔的
                    Thread.sleep(forTimeInterval: 0.035)
                }
            }
            assetReader.cancelReading()
        } catch  {
            print(error)
        }
    }
    
    //MARK: 捕捉视频帧，转换成CGImage
    private func orientationFromAVAssetTrack(_ videoTrack: AVAssetTrack) -> UIImage.Orientation {
        var orientation = UIImage.Orientation.up
        let t = videoTrack.preferredTransform
        if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
            orientation = .right
        }
        else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
            orientation = .left
        }
        else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
            orientation = .up
        }
        else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
            orientation = .down
        }
        return orientation
    }
    
    
    private func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer, rotation: UIImage.Orientation) -> CGImage?
    {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        // Lock the base address of the pixel buffer
        CVPixelBufferLockBaseAddress(imageBuffer, [])
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        // Get the pixel buffer width and height
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        //Generate image to edit
        let pixel = CVPixelBufferGetBaseAddress(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        if let context = CGContext(data: pixel, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            let image = context.makeImage()
            CVPixelBufferUnlockBaseAddress(imageBuffer, [])
            UIGraphicsEndImageContext()
            return image
        }
        return nil
    }
    

}
