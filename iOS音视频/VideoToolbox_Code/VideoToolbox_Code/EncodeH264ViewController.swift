//
//  EncodeH264ViewController.swift
//  VideoToolbox_Code
//
//  Created by CXY on 2018/12/25.
//  Copyright © 2018年 ubtechinc. All rights reserved.
//

import UIKit
import AVFoundation
import VideoToolbox

class EncodeH264ViewController: UIViewController {
    
    fileprivate lazy var captureQueue = DispatchQueue.global()
    fileprivate lazy var encodeQueue = DispatchQueue.global()
    fileprivate var frameID = Int64(0)
    fileprivate var encodingSession: VTCompressionSession?
    
    fileprivate lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .vga640x480
        if let input = deviceInput, session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(videoOuput) {
            session.addOutput(videoOuput)
        }
        return session
    }()
    
    fileprivate var deviceInput: AVCaptureDeviceInput? = {
        guard let device = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: .video, position: .back) else {
            return nil
        }
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            return input
        }
        return input
    }()
    
    fileprivate lazy var videoOuput: AVCaptureVideoDataOutput = {
        var output = AVCaptureVideoDataOutput()
        output.alwaysDiscardsLateVideoFrames = false
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] as [String : Any]
        output.setSampleBufferDelegate(self, queue: captureQueue)
        let connection = output.connection(with: .video)
        connection?.videoOrientation = .portrait
        return output
    }()
    
    fileprivate lazy var previewLayer:AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspect
        return layer
    }()

    fileprivate lazy var fileHandle: FileHandle? = {
        let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last?.appending("/video.h264")
        do {
            try FileManager.default.removeItem(atPath: file!)
            FileManager.default.createFile(atPath: file!, contents: nil, attributes: nil)
        } catch {
            return nil
        }
        return FileHandle(forWritingAtPath: file!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    

    fileprivate func startCapture() {
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        setupVideoToolBox()
        captureSession.startRunning()
    }
    
    fileprivate func stopCapture() {
        captureSession.stopRunning()
        previewLayer.removeFromSuperlayer()
        fileHandle?.closeFile()
    }
    
    fileprivate func setupVideoToolBox() {
        
        
        encodeQueue.sync {
            frameID = 0
            let width = 480
            let height = 640
            var mySelf = self
            let status = VTCompressionSessionCreate(allocator: nil, width: Int32(width), height: Int32(height), codecType: kCMVideoCodecType_H264, encoderSpecification: nil, imageBufferAttributes: nil, compressedDataAllocator: nil, outputCallback: didCompressH264, refcon: UnsafeMutableRawPointer(&mySelf)  , compressionSessionOut: &encodingSession)
            guard let session = encodingSession, status == 0 else {
                print("H264: Unable to create a H264 session")
                return
            }
            
            // 设置实时编码输出（避免延迟）
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_RealTime, value: kCFBooleanTrue)
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_ProfileLevel, value: kVTProfileLevel_H264_Baseline_AutoLevel);
            
            // 设置关键帧（GOPsize)间隔
            var frameInterval = 10
            let frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, CFNumberType.intType, &frameInterval)
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_MaxKeyFrameInterval, value: frameIntervalRef);
            
            // 设置期望帧率
            var fps = 10;
            let fpsRef = CFNumberCreate(kCFAllocatorDefault, CFNumberType.intType, &fps);
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_ExpectedFrameRate, value: fpsRef);
            
            
            //设置码率，均值，单位是byte
            var bitRate = width * height * 3 * 4 * 8;
            let bitRateRef = CFNumberCreate(kCFAllocatorDefault, CFNumberType.sInt32Type, &bitRate);
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_AverageBitRate, value: bitRateRef);
            
            //设置码率，上限，单位是bps
            var bitRateLimit = width * height * 3 * 4;
            let bitRateLimitRef = CFNumberCreate(kCFAllocatorDefault, CFNumberType.sInt32Type, &bitRateLimit);
            VTSessionSetProperty(session, key: kVTCompressionPropertyKey_DataRateLimits, value: bitRateLimitRef);
            
            // Tell the encoder to start encoding
            VTCompressionSessionPrepareToEncodeFrames(session);
        }
    }
    
    var didCompressH264: VTCompressionOutputCallback? = { (pointer, mPointer, status, flags, sampleBuffer)
        in
        
    }
    
    func encode(sampleBuffer: CMSampleBuffer) {
        guard let session = encodingSession, let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
       
        // 帧时间，如果不设置会导致时间轴过长。
        frameID = frameID + 1
        let presentationTimeStamp = CMTimeMake(value: frameID, timescale: 1000);
        let statusCode = VTCompressionSessionEncodeFrame(session, imageBuffer: imageBuffer, presentationTimeStamp: presentationTimeStamp, duration: CMTime.invalid, frameProperties: nil, infoFlagsOut: nil, outputHandler: { OSStatus, flags, sampleBuffer
            in
            
        })
        if statusCode != noErr {
            print("H264: VTCompressionSessionEncodeFrame failed with \(statusCode)")
            VTCompressionSessionInvalidate(session)
            return
        }
        print("H264: VTCompressionSessionEncodeFrame Success")
    }
   
    

}


extension EncodeH264ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
