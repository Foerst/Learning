//
//  ViewController.swift
//  TouchID
//
//  Created by CXY on 2019/8/6.
//  Copyright © 2019 CXY. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        touchIDConfig()
    }
    
    private func touchIDConfig() {
        //首先判断版本
        if NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0 {
            print("系统版本不支持TouchID")
            return
        }
        
        
        let context = LAContext()
        context.localizedFallbackTitle = "输入密码";
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "通过Home键验证已有手机指纹") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                       print("TouchID 验证成功")
                    }
                } else {
                    if let error = error {
                        switch error {
                        case LAError.authenticationFailed:
                            print("授权失败")
                        case LAError.appCancel:
                            print("应用进入后台取消")
                        case LAError.userFallback:
                            print("用户不使用TouchID,选择手动输入密码")
                        case LAError.userCancel:
                            print("TouchID 被用户手动取消")
                        case LAError.passcodeNotSet:
                            print("TouchID 无法启动,因为用户没有设置密码")
                        case LAError.touchIDNotEnrolled:
                            print("TouchID 无法启动,因为用户没有设置TouchID")
                        case LAError.touchIDNotAvailable:
                            print("TouchID 无效")
                        case LAError.touchIDLockout:
                            print("TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)")
                        case LAError.invalidContext:
                            print("当前软件被挂起并取消了授权 (LAContext对象无效)")
                        default:
                            break
                        }
                    }
                }
            }
        } else {
            print("当前设备不支持TouchID")
        }
        
    }


}

