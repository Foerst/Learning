//
//  XYAssetLoader.swift
//  XYPlayer
//
//  Created by CXY on 2019/8/7.
//  Copyright © 2019 CXY. All rights reserved.
//

import UIKit
import AVFoundation

class XYAssetLoader: NSObject {
    
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    
    private var fileWriteHandle: FileHandle?
    
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
    
    private func fillContentInfoRequest(request: AVAssetResourceLoadingContentInformationRequest, withResponse response: URLResponse) {
        request.contentType = response.mimeType
        if let httpResponse = response as? HTTPURLResponse {
            if let acceptRanges = httpResponse.allHeaderFields["Accept-Ranges"] as? String {
                request.isByteRangeAccessSupported = acceptRanges.elementsEqual("bytes")
            }
            if let contentLength = httpResponse.allHeaderFields["Content-Length"] as? String {
                request.contentLength = Int64(contentLength)!
            }
        }
    }
}


extension XYAssetLoader: AVAssetResourceLoaderDelegate {
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        print("\(#function)")
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        print("\(#function)")
        
        var urlComponents = URLComponents(string: (loadingRequest.request.url?.absoluteString)!)
        urlComponents?.scheme = "http"
        
        guard let dataRequest = loadingRequest.dataRequest, let url = urlComponents?.url else {
            print("loadingRequest.dataRequest == nil")
            return false
        }
        
        
        if let contentInfoRequest = loadingRequest.contentInformationRequest {
            if contentInfoRequest.contentLength == 0 {
                var headRequest = URLRequest(url: url)
                headRequest.httpMethod = "HEAD"
                let dataTask = session.dataTask(with: headRequest) { (data, response, error) in
                    if let response = response {
                        self.fillContentInfoRequest(request: contentInfoRequest, withResponse: response)
                        loadingRequest.finishLoading()
                    }
                }
                dataTask.resume()
            }
        } else {
            let requestedOffset = Int(dataRequest.requestedOffset)
            let requestedLength = dataRequest.requestedLength
            var allHTTPHeaderFields = ["Range" : "bytes=\(requestedOffset)-\(requestedOffset + requestedLength - 1)"]
            if dataRequest.requestsAllDataToEndOfResource {
                allHTTPHeaderFields = ["Range" : "bytes=\(requestedOffset)-"]
            }
            
            var dataRequest = URLRequest(url: url)
            dataRequest.httpMethod = "GET"
            dataRequest.cachePolicy = .returnCacheDataElseLoad
            for (headerField, headerValue) in allHTTPHeaderFields {
                dataRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
            
            let dataTask = session.dataTask(with: dataRequest) { (data, response, error) in
                guard error == nil else { return }
                if let sliceData = data {
                    loadingRequest.dataRequest?.respond(with: sliceData)
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
        }
        return true
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
