//
//  AppDelegate.swift
//  CatFactsEveryday
//
//  Created by Антон Адамсон on 23.09.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // !! I don't thing AppDelegate is a good place to store this persistentContainer. You could create some AppContext which would hold some CatService where you would have some human-readable functions like saveCatFact and getCatFacts and this CatService could incapsulate the persistentContainer. CoreData is details of imaplementation, it could be Realm or some other database so it should be hidden from the user of the service and be possible to change datails without changing the interface.
    // Я не думаю, что AppDelegate является хорошим местом для хранения этого persistentContainer. Вы можете создать некоторый AppContext, который будет содержать некоторый CatService, где у вас будут некоторые человекочитаемые функции, такие как saveCatFact и getCatFacts, и этот CatService может инкапсулировать persistentContainer. CoreData - это детали инкапсуляции, это может быть Realm или какая-либо другая база данных, поэтому она должна быть скрыта от пользователя сервиса и иметь возможность изменять данные без изменения интерфейса.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // !! It's to harsh way to handle an error. I would rather show an alert message instead
                // Это слишком грубый способ обработки ошибок. Я бы предпочел выводить предупреждающее сообщение.
                fatalError("Не удалось загрузить хранилище данных: \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // !! I would recomment to use SceneDelegate already for this kind of adjustments
        // Я бы рекомендовал использовать SceneDelegate уже для такого рода настроек
        APICaller.shared.setup()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // ОК!! I would remove these commented lines, it looks excessive
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // ОК!! I would remove all the AppDelegate and SceneDelegate methods which are not used.
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

