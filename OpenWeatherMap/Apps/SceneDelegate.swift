//
//  SceneDelegate.swift
//  OpenWeatherMap
//
//  Created by Ильдар on 07.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowsScene.coordinateSpace.bounds)
        window?.windowScene = windowsScene
        
        let mainVC = ModuleBuilder.createMainModule()
        let navBar = UINavigationController(rootViewController: mainVC)
        
        window?.rootViewController = navBar
        window?.makeKeyAndVisible()
    }
}
