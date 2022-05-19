//
//  PhotosListInteractor.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import RxSwift

protocol PhotosListInteractorProtocol: AnyObject {
    func fetchRecentPhotos(page: Int, perPage: Int) -> Observable<(PhotosListModel)>
    func searchPhotos(searchText: String, page: Int, perPage: Int) -> Observable<(PhotosListModel)>
}

class PhotosListInteractor: PhotosListInteractorProtocol {
    
    var networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = AlamofireManager()) {
        self.networkManager = networkManager
    }

    var request: PhotosListRequest?

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
