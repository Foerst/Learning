//
//  XYAssetManager.swift
//  AVFoundationDemo
//
//  Created by CXY on 2019/1/26.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

import UIKit
import AVFoundation

class XYAssetLoader: NSObject {
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        return session
    }()
    
    private lazy var dataTasks = [URLSessionDataTask]()
    
    private var fileWriteHandle: FileHandle?
    
    private var offSet = UInt64(0)
    
    override init() {
        super.init()
        let fileManager = FileManager.default
        let foldPath = NSTemporaryDirectory().appending("/XYCache")
        if !fileManager.fileExists(atPath: foldPath) {
            do {
                try fileManager.createDirectory(atPath: foldPath, withIntermediateDirectories: true, attributes: nil)
                if !fileManager.fileExists(atPath: foldPath.appending("/tmp.mp4")) {
                    fileManager.createFile(atPath: foldPath.appending("/tmp.mp4"), contents: nil, attributes: nil)
                }
            } catch {
                print(error)
            }
            fileWriteHandle = FileHandle(forWritingAtPath: foldPath.appending("/tmp.mp4"))
        }
    }
    
    deinit {
        print("\(#function)")
        fileWriteHandle?.closeFile()
    }

}


extension XYAssetLoader: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        
        print("\(#function)")
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("\(#function)   \(loadingRequest)")
        
        guard let dataRequest = loadingRequest.dataRequest else {
            print("loadingRequest.dataRequest == nil")
            return false
        }
        var urlComponents = URLComponents(string: (loadingRequest.request.url?.absoluteString)!)
        urlComponents?.scheme = "https"
        
        // 第一次调用时产生的loadingRequest中一定是一个请求范围为0-2的请求，服务端针对该请求的返回中包含了所请求文件的长度、类型等文件信息，这为AVPlayer发起后续loadingRequest提供了依据，因此，一定要对首个loadingRequest进行finishLoading
        if let contentInfoRequest = loadingRequest.contentInformationRequest {
            if contentInfoRequest.contentLength == 0 {
                do {
                    print("\((urlComponents?.url)!)")
                    let headRequest = try URLRequest(url: (urlComponents?.url)!, method: .head, headers: nil)
                    let dataTask = session.dataTask(with: headRequest) { (data, response, error) in
                        if let res = response {
                            self.fillContentInfoRequest(loadingRequest.contentInformationRequest, with: res)
                            loadingRequest.finishLoading()
                        }
                    }
                    
                    // 这种方式会走代理方法
                    // let dataTask = session.dataTask(with: headRequest)
                    dataTask.resume()
                    
                } catch {
                    print(error)
                }
            }
        } else {
            
            let requestedOffset = Int(dataRequest.requestedOffset)
            let requestedLength = dataRequest.requestedLength
            var allHTTPHeaderFields = ["Range" : "bytes=\(requestedOffset)-\(requestedOffset + requestedLength - 1)"]
            if dataRequest.requestsAllDataToEndOfResource {
                allHTTPHeaderFields = ["Range" : "bytes=\(requestedOffset)-"]
            }
            
            do {
                
                var request = try URLRequest(url: (urlComponents?.url)!, method: .get, headers: allHTTPHeaderFields)
                request.cachePolicy = .returnCacheDataElseLoad
                let dataTask = session.dataTask(with: request) { (data, response, error) in
                    guard error == nil else {
                        return
                    }
                    if let sliceData = data {
                        dataRequest.respond(with: sliceData)
                        loadingRequest.finishLoading()
                        // 保存数据
                        if sliceData.count > 0 {
                            print("sliceData.count > 0")
                            self.fileWriteHandle?.write(sliceData)
                            self.fileWriteHandle?.synchronizeFile()
                            self.fileWriteHandle?.seekToEndOfFile()
                        }
                    }
                }
                dataTask.resume()
            } catch {
                print(error)
            }
        }
        
        
        return true
    }
    
    private func fillContentInfoRequest(_ request: AVAssetResourceLoadingContentInformationRequest?, with response: URLResponse) {
        request?.contentType = response.mimeType
        if let httpResponse = response as? HTTPURLResponse {
            if let acceptRanges = httpResponse.allHeaderFields["Accept-Ranges"] as? String {
                request?.isByteRangeAccessSupported = acceptRanges.elementsEqual("bytes")
            }
            if let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String {
                request?.contentLength = Int64(contentLength)!
            }
        }
    }
}

extension XYAssetLoader: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("\(#function)")
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        print("\(#function)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("\(#function)")
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        print("\(#function)")
    }
}
