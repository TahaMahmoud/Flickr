//
//  PhotosListInteractorMock.swift
//  FlickrTests
//
//  Created by Taha on 22/05/2022.
//

import Foundation
import RxSwift
@testable import Flickr

class PhotosListInteractorMock: PhotosListInteractorProtocol {
    
    let stubGenerator: StubGenerator = StubGenerator()

    func fetchRecentPhotos(page: Int, perPage: Int) -> Observable<(PhotosListModel)> {
        return Observable.create {[weak self] (observer) -> Disposable in
            let photos = self?.stubGenerator.fetchRemotPhotos()
            observer.onNext(photos!)
            return Disposables.create()
        }
    }
    
    func searchPhotos(searchText: String, page: Int, perPage: Int) -> Observable<(PhotosListModel)> {
        return Observable.create {[weak self] (observer) -> Disposable in
            let photos = self?.stubGenerator.fetchRemotPhotos()
            observer.onNext(photos!)
            return Disposables.create()
        }
    }
    
    func fetchCachedPhotos() -> Observable<[String]> {
        return Observable.create {[weak self] (observer) -> Disposable in
            let photos = self?.stubGenerator.fetchCachedPhotos()
            observer.onNext(photos!)
            return Disposables.create()
        }
    }
    
    func savePhoto(photoURL: String) -> Observable<Bool> {
        return Observable.create {[weak self] (observer) -> Disposable in
            if !(self?.stubGenerator.photos.contains(photoURL) ?? true){
                self?.stubGenerator.photos.append(photoURL)
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            return Disposables.create()
        }
    }
    
    func removeAllPhotos() -> Observable<Bool> {
        return Observable.create {[weak self] (observer) -> Disposable in
            self?.stubGenerator.photos.removeAll()
            observer.onNext(true)
            return Disposables.create()
        }
    }
    
    func isPhotoStored(photoURL: String) -> Observable<Bool> {
        return Observable.create {[weak self] (observer) -> Disposable in
            observer.onNext(self?.stubGenerator.photos.contains(photoURL) ?? false)
            return Disposables.create()
        }
    }
    
}
