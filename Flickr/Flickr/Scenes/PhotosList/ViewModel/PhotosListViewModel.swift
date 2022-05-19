//
//  PhotosListViewModel.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol PhotosListViewModelOutput {
    func photoViewModelAtIndexPath(_ indexPath: IndexPath) -> PhotoCellViewModel
    
    var indicator: PublishSubject<Bool> { get set }
    var error: PublishSubject<String> { get set }
}

protocol PhotosListViewModelInput {
    func viewDidLoad()
    func didScroll(searchText: String, indexPath: IndexPath)
    func didSelectItemAtIndexPath(_ indexPath: IndexPath)
    
    func search(searchText: String)
    
    func didImageDownloaded(photoURL: String)

}

class PhotosListViewModel: PhotosListViewModelInput, PhotosListViewModelOutput {
    
    private let coordinator: PhotosListCoordinatorProtocol
    let disposeBag = DisposeBag()
    
    let perPage = 20
    
    var photos: BehaviorRelay<[PhotoCellViewModel]> = .init(value: [])

    var indicator: PublishSubject<Bool> = .init()
    var error: PublishSubject<String> = .init()
    
    private let photosListInteractor: PhotosListInteractorProtocol
    
    init(photosListInteractor: PhotosListInteractorProtocol = PhotosListInteractor(networkManager: AlamofireManager()), coordinator: PhotosListCoordinatorProtocol) {
        self.photosListInteractor = photosListInteractor
        self.coordinator = coordinator
    }
    
    func viewDidLoad(){
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        
        indicator.onNext(true)
        
        let fetchedPhotos = photos.value.count
        
        // Calculate Page No
        let page = ( fetchedPhotos / perPage ) + 1
        
        if Helper.checkConnection() {
            removeCachedPhotos()
            fetchRemotePhotos(page: page)
        } else {
            fetchCachedPhotos()
        }
    }
    
    private func fetchRemotePhotos(page: Int) {
        
        photosListInteractor.fetchRecentPhotos(page: page, perPage: perPage).subscribe{ (response) in
        
            var photosList: [PhotoCellViewModel] = self.photos.value
            

            for photo in response.element?.photos?.photo ?? [] {
                
                var photoURL = ""
                    photoURL = "http://farm\(photo.farm ?? 0).static.flickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
                
                photosList.append(PhotoCellViewModel(photoURL: photoURL, isAdBanner: false))
            }
            
            let adBanner = PhotoCellViewModel(photoURL: "https://media-exp1.licdn.com/dms/image/C561BAQEC_N7NCtL19w/company-background_10000/0/1581693327818?e=2147483647&v=beta&t=zPGQL4hWdt6htCExvThJgSDgjb8OnRyire4UkzzRHT8", isAdBanner: true)

            // Add Ad Banner to PhotosList

            let newPhotosList = Array(photosList.chunks(of: 5).joined(separator: [adBanner]))

            self.photos.accept(newPhotosList)
            
            self.indicator.onNext(false)
            
        }.disposed(by: disposeBag)
    }
    
    private func fetchCachedPhotos() {
        
        photosListInteractor.fetchCachedPhotos().subscribe{ (response) in
        
            var photosList: [PhotoCellViewModel] = self.photos.value
            
            for photoURL in response.element ?? [] {
                                
                photosList.append(PhotoCellViewModel(photoURL: photoURL, isAdBanner: false))
            }
            
            print("Cached Photos")
            print(photosList)
            
            self.photos.accept(photosList)
            
            self.indicator.onNext(false)
            
        }.disposed(by: disposeBag)
        
    }
    
    func photoViewModelAtIndexPath(_ indexPath: IndexPath) -> PhotoCellViewModel {
        return PhotoCellViewModel(photoURL: photos.value[indexPath.row].photoURL ?? "", isAdBanner: photos.value[indexPath.row].isAdBanner)
    }

    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        coordinator.pushToPhotoDetails(with: "")
    }

    func didScroll(searchText: String, indexPath: IndexPath) {
        // Pagination
        if indexPath.row == photos.value.count - 3 && photos.value.count != 3 {
            if searchText != "" {
                search(searchText: searchText)
            } else {
                fetchPhotos()
            }
        }
    }

    func search(searchText: String) {
        indicator.onNext(true)
        
        photos.accept([])
        
        let fetchedPhotos = photos.value.count
        
        // Calculate Page No
        let page = ( fetchedPhotos / perPage ) + 1
        
        if Helper.checkConnection() {
            fetchSearch(searchText: searchText, page: page)
        } else {
            
        }

    }
    
    func fetchSearch(searchText: String, page: Int) {
        
        photosListInteractor.searchPhotos(searchText: searchText, page: page, perPage: perPage).subscribe{ (response) in
        
            var photosList: [PhotoCellViewModel] = self.photos.value

            for photo in response.element?.photos?.photo ?? [] {
                
                var photoURL = ""
                    photoURL = "http://farm\(photo.farm ?? 0).static.flickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
                
                photosList.append(PhotoCellViewModel(photoURL: photoURL, isAdBanner: false))
            }
            
            let adBanner = PhotoCellViewModel(photoURL: "https://media-exp1.licdn.com/dms/image/C561BAQEC_N7NCtL19w/company-background_10000/0/1581693327818?e=2147483647&v=beta&t=zPGQL4hWdt6htCExvThJgSDgjb8OnRyire4UkzzRHT8", isAdBanner: true)

            // Add Ad Banner to PhotosList

            let newPhotosList = Array(photosList.chunks(of: 5).joined(separator: [adBanner]))

            self.photos.accept(newPhotosList)

            self.indicator.onNext(false)
            
        }.disposed(by: disposeBag)

        
    }

    func didImageDownloaded(photoURL: String) {
        if Helper.checkConnection() {
            photosListInteractor.savePhoto(photoURL: photoURL).subscribe{ (response) in
                print("\(photoURL) ... Downloaded")
            }.disposed(by: disposeBag)
        }
    }
    
    func removeCachedPhotos() {
        photosListInteractor.removeAllPhotos().subscribe { (respone) in
            print("Cached Photos Removed")
        }.disposed(by: disposeBag)
    }
}
