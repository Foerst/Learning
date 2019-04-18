//
//  XYAssetManager.swift
//  AVFoundationDemo
//
//  Created by CXY on 2019/2/15.
//  Copyright © 2019年 ubtechinc. All rights reserved.
//

import UIKit

private struct XYAssetManagerKey {
    static var zone = "zone"
    static var size = "size"
    static var responseHeaders = "responseHeaders"
}

class XYAssetManager: NSObject {
    private var cacheFilePath: String?
    private var idxFilePath: String?
    private var fileLength = 0
    private lazy var ranges = [String]()
    private var writeHandle: FileHandle?
    private var readHandle: FileHandle?
    private let idxExtension = ".idx!"
    
    static func cacheFileWithPath(_ path: String) -> XYAssetManager {
        return XYAssetManager(path: path)
    }
    
    init(path: String) {
        if path.isEmpty { return }
        cacheFilePath = path
        idxFilePath = path.appendingFormat("%@", idxExtension)
        let cacheFileExist = FileManager.default.fileExists(atPath: cacheFilePath!)
        let idxFileExist = FileManager.default.fileExists(atPath: idxFilePath!)
        let fileExist = cacheFileExist && idxFileExist
        if !fileExist, let directory = (cacheFilePath as NSString?)?.deletingPathExtension {
            if !FileManager.default.fileExists(atPath: directory) {
                do {
                    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
                    if !FileManager.default.createFile(atPath: cacheFilePath!, contents: nil, attributes: nil) {
                        return
                    }
                    if !FileManager.default.createFile(atPath: idxFilePath!, contents: nil, attributes: nil) {
                        return
                    }
                } catch {
                    print(error)
                }
                
            }
        }
        
        readHandle = FileHandle(forReadingAtPath: cacheFilePath!)
        writeHandle = FileHandle(forWritingAtPath: cacheFilePath!)
        
    }
    
    deinit {
        readHandle?.closeFile()
        writeHandle?.closeFile()
    }
}
