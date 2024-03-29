//
//  SceneDelegate.swift
//  7_social_network_01
//
//  Created by Alvaro Choque on 29/6/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    static weak var shared: SceneDelegate?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Self.shared = self
        let localUser = CoreDataManager.shared.getData()
        setupRootControllerIfNeeded(validUser: !localUser.isEmpty)
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = self.window
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func setupRootControllerIfNeeded(validUser: Bool) {
        // TODO: - User real data to check if there is a valid user.
        //let validUser = false
        if validUser {
            // Create VC for TabBar
            let rootViewController = getRootViewControllerForValidUser()
            self.window?.rootViewController = rootViewController
        } else {
            let rootViewController = getRootViewControllerForInvalidUser()
            self.window?.rootViewController = rootViewController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewControllerForInvalidUser() -> UIViewController {
        let navController = UINavigationController(rootViewController: LoginViewController())
        return navController
    }
    
    func getRootViewControllerForValidUser() -> UIViewController {
        // Create TabBarVC
        let tabBarVC = UITabBarController()
        tabBarVC.tabBar.isTranslucent = false
        tabBarVC.tabBar.barTintColor = .black
//        tabBarVC.view.backgroundColor = .blue
//        UITabBar.appearance().barTintColor = .black
        
        
        // Add VCs to TabBarVC
        tabBarVC.viewControllers = [
            createNavController(for: MangaListViewController(), title: "Mangas", image: UIImage(systemName: "newspaper.fill")!),
            
            createNavController(for: AuthorListViewController(), title: "Authors", image: UIImage(systemName: "person.3.sequence.fill")!),
            
            createNavController(for: FriendsViewController(), title: "Friends", image: UIImage(systemName: "message.fill")!),
            
            createNavController(for: ProfileViewController(), title: "Profile", image: UIImage(systemName: "person.fill")!)
        ]
        
        return tabBarVC
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
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
        CoreDataManager.shared.saveContext()
    }
}

