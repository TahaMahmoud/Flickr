//
//  PhotosListInteractor.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import RxSwift

protocol PhotosListInteractorProtocol: AnyObject {
    func fetchRemotePhotos() -> Observable<(PhotosListModel)>
}

class PhotosListInteractor: PhotosListInteractorProtocol {
    
    var networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = AlamofireManager()) {
        self.networkManager = networkManager
    }

    var request: PhotosListRequest?

    func fetchRemotePhotos() -> Observable<(PhotosListModel)> {
        return Observable.create {[weak self] (observer) -> Disposable in
            self?.networkManager.callRequest(PhotosListModel.self, endpoint: PhotosListRequest.fetchPhotos) { (result) in
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
