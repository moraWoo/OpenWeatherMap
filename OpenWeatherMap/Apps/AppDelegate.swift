//
//  AppDelegate.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 07.12.2022.
//

import UIKit

final class ThemeWindow: UIWindow {
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if Theme.current == .system {
            DispatchQueue.main.async {
                Theme.system.setActive()
            }
        }
    }
}

let themeWindow = ThemeWindow()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DispatchQueue.main.async {
            Theme.dark.setActive()
        }
        themeWindow.makeKey()
        
        return true
    }
    
    
}

