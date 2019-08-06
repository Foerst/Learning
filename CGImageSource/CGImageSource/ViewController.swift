//
//  ViewController.swift
//  CGImageSource
//
//  Created by CXY on 2017/6/27.
//  Copyright © 2017年 CXY. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
    
    private lazy var recvData = Data()
    
    private lazy var incrementallyImgSource = CGImageSourceCreateIncremental(nil)
    
    private(set) var isFinished = false
    
    private let downloadUrl = URL(string: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1498568143537&di=7261f6778aa9adad47f815dec7ca04c0&imgtype=0&src=http%3A%2F%2Fd.lanrentuku.com%2Fdown%2Fpng%2F1212%2Fchristmas_icon_set_by_mkho%2Fcandles.png")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session.downloadTask(with: downloadUrl).resume()
//        session.dataTask(with: downloadUrl).resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
    }

}


extension ViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let err = error {
            print(err)
        }
    }
}


extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        isFinished = true
        do {
            let data = try Data(contentsOf: location)
            let image = UIImage(data: data)
            imageView.image = image
        } catch {
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
    }
    
}


extension ViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        recvData.append(data)
        CGImageSourceUpdateData(incrementallyImgSource, recvData as CFData, isFinished)
        let imageRef = CGImageSourceCreateImageAtIndex(incrementallyImgSource, 0, nil)
        if let cgImage = imageRef {
            imageView.image = UIImage(cgImage: cgImage)
        }
    }
}
