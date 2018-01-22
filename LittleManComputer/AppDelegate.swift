//
//  AppDelegate.swift
//  LittleManComputer
//
//  Created by Thomas Rademaker on 9/18/16.
//  Copyright © 2016 SparrowTek LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = .sparrowTekGreen() // image/text color when selected
        UITabBar.appearance().barTintColor = .white // bar color
        UITabBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .sparrowTekGreen()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.sparrowTekGreen()]
        //UINavigationBar.appearance().barStyle = .black
        
        return true
    }
}

