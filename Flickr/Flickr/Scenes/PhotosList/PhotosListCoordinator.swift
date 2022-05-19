//
//  PhotosListCoordinator.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import UIKit

protocol PhotosListCoordinatorProtocol: AnyObject {
    func pushToPhotoDetails(with photo: String)
}

class PhotosListCoordinator: Coordinator{
    
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    func start() {
        let photosListViewController = PhotosListViewController()
        var interactor: PhotosListInteractorProtocol?
        let photosListViewModel = PhotosListViewModel(photosListInteractor: PhotosListInteractor(), coordinator: self)
        photosListViewController.viewModel = photosListViewModel
        navigationController.setViewControllers([photosListViewController], animated: true)
    }
}

extension PhotosListCoordinator: PhotosListCoordinatorProtocol {
    
    func pushToPhotoDetails(with photo: String) {
        
    }
        
}
