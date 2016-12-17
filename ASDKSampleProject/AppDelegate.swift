//
//  AppDelegate.swift
//  ASDKSampleProject
//
//  Created by Leo Tumwattana on 17/12/2016.
//  Copyright © 2016 Stay Sorted Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

