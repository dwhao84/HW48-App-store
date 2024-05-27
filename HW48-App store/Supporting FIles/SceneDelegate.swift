//
//  SceneDelegate.swift
//  HW48-App store
//
//  Created by Dawei Hao on 2024/5/8.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Create a UITabBarController and add the navigation controller to it.
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            createTodayNC(),
            createGamesNC(),
            createAppNC(),
            createArcadeNC(),
            createSearchNC()
        ]
        
        let appearance = UITabBarAppearance()
        window.rootViewController = tabBarController // Set the rootViewController of the window to the tabBarController.
        tabBarController.selectedIndex = 2           // Set up index to specific VC.
        tabBarController.selectedIndex = 2            // Set up index to specific VC.
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        tabBarController.tabBar.standardAppearance   = appearance
        
        // Set the window and make it visible.
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func createTodayNC () -> UINavigationController {
        let todayVC = TodayViewController()
        let todayNC = UINavigationController(rootViewController: todayVC)
        todayNC.tabBarItem.title = "Today"
        todayNC.tabBarItem.image = Images.today
        return todayNC
    }
    
    func createGamesNC () -> UINavigationController {
        let gameVC = GamesViewController()
        let gameNC = UINavigationController(rootViewController: gameVC)
        gameNC.tabBarItem.title = "Games"
        gameNC.tabBarItem.image = Images.games
        return gameNC
    }
    
    func createAppNC () -> UINavigationController {
        let appStoreVC = AppStoreViewController()
        let appStoreNC = UINavigationController(rootViewController: appStoreVC)
        appStoreNC.tabBarItem.title = "Apps"
        appStoreNC.tabBarItem.image = Images.app
        return appStoreNC
    }

    func createArcadeNC () -> UINavigationController {
        let arcadeVC = ArcadeViewController()
        let arcadeNC = UINavigationController(rootViewController: arcadeVC)
        arcadeNC.tabBarItem.title = "Arcade"
        arcadeNC.tabBarItem.image = Images.arcade
        return arcadeNC
    }
    
    func createSearchNC () -> UINavigationController {
        let searchVC = SearchViewController()
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.tabBarItem.title = "Search"
        searchNC.tabBarItem.image = Images.search
        return searchNC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

