//
//  AppDelegate.swift
//  TaskHub
//
//  Created by Kirill Taraturin on 18.09.2023.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }
    
    // сохраняем все изменения при выходе из приложения
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

