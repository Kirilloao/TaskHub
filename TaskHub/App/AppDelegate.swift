//
//  AppDelegate.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navBarAppearance = UINavigationBarAppearance()
        
        // Устанавливаем цвет для navigationBar
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        // Меняем цвет для текста
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Меняем цвет в статичном положении и в скроллинге
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        // меняем цвет кнопки назад
        UINavigationBar.appearance().tintColor = .white
        
        return true
        
    }
    
    // сохраняем все изменения при выходе из приложения
    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.shared.saveContext()
    }
}

