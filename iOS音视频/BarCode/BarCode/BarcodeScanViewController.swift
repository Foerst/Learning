//
//  ViewController.swift
//  BarCode
//
//  Created by CXY on 2020/2/28.
//  Copyright © 2020 CXY. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate let SCREEN_WIDTH = UIScreen.main.bounds.width
fileprivate let boxTop: CGFloat = 135
fileprivate let boxWidth = SCREEN_WIDTH - 118
fileprivate let lineHeight: CGFloat = 2

class BarcodeScanViewController: UIViewController {
    
    private var session: AVCaptureSession?
    
    var finishedCallback: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "扫码"
        setupCamera()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session?.startRunning()
        line.removeAnimation(forKey: "move")
        line.add(moveAnimation, forKey: "move")
    }
    
    private func setupUI() {
        view.addSubview(bgLayer)
        bgLayer.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
        view.addSubview(boxImage)
        boxImage.snp.makeConstraints { (mk) in
            mk.centerX.equalToSuperview()
            mk.width.height.equalTo(boxWidth)
            mk.top.equalTo(boxTop)
        }
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.height.equalTo(21)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalTo(boxImage.snp.bottom).offset(10)
        }
        boxImage.layer.addSublayer(line)
        line.frame = CGRect(x: 1, y: 0, width: boxWidth-2, height: lineHeight)
        line.add(moveAnimation, forKey: "move")
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            
            session = AVCaptureSession()
            if session!.canSetSessionPreset(.high) {
                session?.sessionPreset = .high
            }
            if session!.canAddInput(input) {
                session?.addInput(input)
            }
            if session!.canAddOutput(output) {
                session?.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: .main)
                
                // 设置同时支持二维码和条形码，正常情况下同时设置会出问题，后面需要设置rectOfInterest
                output.metadataObjectTypes = [.code128, .ean13, .ean8, .qr]
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session!)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = self.view.bounds
            self.view.layer.addSublayer(previewLayer)
            
            //放大焦距
            try device.lockForConfiguration()
            device.videoZoomFactor = min(device.activeFormat.videoMaxZoomFactor, 2)
            device.unlockForConfiguration()
            
            session?.startRunning()

            let frame = CGRect(x: (SCREEN_WIDTH-boxWidth)/2, y: boxTop, width: boxWidth, height: boxWidth)
            // 计算output的rectOfInterest，也有其他方式(参考：https://www.jianshu.com/p/8bb3d8cb224e)，这里采用系统自带方式
            let intertRect = previewLayer.metadataOutputRectConverted(fromLayerRect: frame)
            //11.必须在startRunning之后才会生效（坑哦）
            // 当AVFoundation使用多译码器扫描的时候,扫码会出现问题的结局方案
            output.rectOfInterest = intertRect
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    
    private lazy var bgLayer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.layer.mask = self.maskLayer
        return view
    }()
    
    private lazy var maskLayer: CALayer = {
        let mask = CAShapeLayer()
        let path = UIBezierPath(rect: UIScreen.main.bounds)
        path.append(UIBezierPath(rect: CGRect(x: (SCREEN_WIDTH-boxWidth)/2, y: boxTop, width: boxWidth, height: boxWidth)).reversing())
        mask.path = path.cgPath
        return mask
    }()
    
    private lazy var boxImage = UIImageView(image: UIImage(named: "bar_scan_box"))
    
    private lazy var line: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1).cgColor
        return layer
    }()
    
    private lazy var tipLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.text = "放入框内，自动扫描"
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    private lazy var moveAnimation: CABasicAnimation = {
        let ani = CABasicAnimation()
        ani.keyPath = "position.y"
        ani.fromValue = 0
        ani.toValue = boxWidth
        ani.duration = 2.0
        ani.repeatCount = MAXFLOAT
        return ani
    }()
}


extension BarcodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        if !metadataObjects.isEmpty {
            if let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let code = obj.stringValue, !code.isEmpty {
                navigationController?.popViewController(animated: true)
                debugPrint("扫码结果： \(code)")
                finishedCallback?(code)
                let vc = ScanResultViewController()
                vc.result = code
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
}

