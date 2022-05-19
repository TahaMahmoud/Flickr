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
    func didSelectItemAtIndexPath(_ indexPath: IndexPath)
}

class PhotosListViewModel: PhotosListViewModelInput, PhotosListViewModelOutput {

    private let coordinator: PhotosListCoordinatorProtocol
    let disposeBag = DisposeBag()
    
    var photos: BehaviorRelay<[PhotoCellViewModel]> = .init(value: [])
    var navigateToItemDetails: PublishSubject<PhotoCellViewModel> = .init()

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
        
        if Helper.checkConnection() {
            fetchRemotePhotos()
        } else {
            
        }
    }
    
    private func fetchRemotePhotos() {
        photosListInteractor.fetchRemotePhotos().subscribe{ (response) in
            
            var photosList: [PhotoCellViewModel] = []
            var index = 0
            var isAdBanner = false
            
            for photo in response.element?.photos?.photo ?? [] {
                
                var photoURL = ""
                
                if index == 5 {
                    // Add Ad Banner
                    photoURL = "https://media-exp1.licdn.com/dms/image/C561BAQEC_N7NCtL19w/company-background_10000/0/1581693327818?e=2147483647&v=beta&t=zPGQL4hWdt6htCExvThJgSDgjb8OnRyire4UkzzRHT8"
                    isAdBanner = true
                } else {
                    photoURL = "http://farm\(photo.farm ?? 0).static.flickr.com/\(photo.server ?? "")/\(photo.id ?? "")_\(photo.secret ?? "").jpg"
                    isAdBanner = false
                }
                
                index = index + 1
                
                photosList.append(PhotoCellViewModel(photoURL: photoURL, isAdBanner: isAdBanner))
            }
            
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

}
