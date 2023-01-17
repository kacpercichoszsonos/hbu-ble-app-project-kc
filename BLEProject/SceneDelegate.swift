//
//  SceneDelegate.swift
//  BLEProject
//
//  Created by Kacper Cichosz on 14/11/2022.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: TabBarView())
        window.makeKeyAndVisible()
        self.window = window
    }
}

