//
//  SceneDelegate.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let categoryVC = CategoryViewController()
//        let listVC = ToDoListViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: categoryVC)
        
        window?.makeKeyAndVisible()
    }
}

