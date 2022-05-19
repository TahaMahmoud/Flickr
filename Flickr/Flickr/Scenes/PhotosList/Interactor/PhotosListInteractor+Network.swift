//
//  PhotosListInteractor.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import CoreData
import RxSwift

protocol PhotosListInteractorProtocol: AnyObject {
    func fetchRecentPhotos(page: Int, perPage: Int) -> Observable<(PhotosListModel)>
    func searchPhotos(searchText: String, page: Int, perPage: Int) -> Observable<(PhotosListModel)>
    
    func fetchCachedPhotos() -> Observable<[String]>
    func savePhoto(photoURL: String) -> Observable<Bool>
    func removeAllPhotos() -> Observable<Bool>

    func isPhotoStored(photoURL: String) -> Observable<Bool>
}

class PhotosListInteractor: PhotosListInteractorProtocol {
    
    var networkManager: NetworkProtocol
    var coreDataManager: CoreDataManager
    
    init(networkManager: NetworkProtocol = AlamofireManager()) {
        self.networkManager = networkManager
        self.coreDataManager = CoreDataManager()
    }

    var request: PhotosListRequest?

    var cachedPhotos: [String] = []
    
    func fetchRecentPhotos(page: Int, perPage: Int) -> Observable<(PhotosListModel)> {
        return Observable.create {[weak self] (observer) -> Disposable in
            self?.networkManager.callRequest(PhotosListModel.self, endpoint: PhotosListRequest.fetchPhotos(page: page, perPage: perPage)) { (result) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }

    }
        
    func searchPhotos(searchText: String, page: Int, perPage: Int) -> Observable<(PhotosListModel)> {
        return Observable.create {[weak self] (observer) -> Disposable in
            self?.networkManager.callRequest(PhotosListModel.self, endpoint: PhotosListRequest.searchPhotos(searchText: searchText, page: page, perPage: perPage)) { (result) in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }

    }
}
