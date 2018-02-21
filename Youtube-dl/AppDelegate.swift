//
//  AppDelegate.swift
//  Youtube-dl
//
//  Created by Chen Zerui on 17/2/18.
//  Copyright © 2018 Chen Zerui. All rights reserved.
//

import UIKit
import Nuke
import YoutubeClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var topViewControler: UIViewController?{
        guard var current = window?.rootViewController else{
            return nil
        }
        
        while let next = current.parent{
            current = next
        }
        
        return current
    }
    
    static var shared: AppDelegate!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.shared = self
        
        if !FileManager.default.fileExists(atPath: Constants.downloadsURL.path){
            try! FileManager.default.createDirectory(at: Constants.downloadsURL, withIntermediateDirectories: false, attributes: [:])
        }
        return true
    }
    
}

