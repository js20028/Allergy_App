//
//  AppDelegate.swift
//  AllergyApp
//
//  Created by 곽재선 on 2022/05/29.
//

import UIKit
import CoreData
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 네트워크 감지
        startMonitoring()
        
        sleep(1)
        
//        for family in UIFont.familyNames{
//            print(family)
//            for name in UIFont.fontNames(forFamilyName: family){
//                print(name)
//            }
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreAllergyModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

extension AppDelegate {
    
    // 네트워크 실시간 감지
    func startMonitoring() {
        
        let monitor = NWPathMonitor()
        
        let alert = UIAlertController(title: "인터넷 연결이 원활하지 않습니다.", message: "와이파이나 데이터 연결을 확인해주세요", preferredStyle: .alert)
        // 확인 버튼 누르면 앱 재실행
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            exit(0)
        }
        alert.addAction(okAction)
        
        monitor.start(queue: .global())
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("연결되있음")
                
            } else {
                print("연결끊겨있음")
                
                DispatchQueue.main.async {
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }
}
