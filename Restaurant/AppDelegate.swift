//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Marc Batete on 11/20/19.
//  Copyright © 2019 Marc Batete. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           let temporaryDirectory = NSTemporaryDirectory()
           let urlCache = URLCache(memoryCapacity: 25000000, diskCapacity: 50000000, diskPath: temporaryDirectory)
           URLCache.shared = urlCache
           
           return true
       }



}

