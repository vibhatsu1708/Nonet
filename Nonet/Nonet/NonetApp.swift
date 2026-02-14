//
//  NonetApp.swift
//  Nonet
//
//  Created by Vedant Mistry on 14/02/26.
//

import GoogleMobileAds
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        MobileAds.shared.start(completionHandler: nil)
        return true
    }
}

@main
struct NonetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
