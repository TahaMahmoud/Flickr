//
//  AppCoordinator.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}


class AppCoordinator: Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            navigationController.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
                
        // let photosListCoordinator = PhotosListCoordinator(navigationController: navigationController)
        // coordinate(to: photosListCoordinator)
    }
}
