//
//  PhotosListViewModelTests.swift
//  FlickrTests
//
//  Created by Taha on 22/05/2022.
//

import XCTest
import RxSwift
@testable import Flickr

class PhotosListViewModelTests: XCTestCase {

    var sut: PhotosListViewModel!
    var interactorMock: PhotosListInteractorMock!
    var coordinatorMock: PhotosListCoordinatorMock!
    
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
    
        interactorMock = PhotosListInteractorMock()
        coordinatorMock = PhotosListCoordinatorMock()
        
        sut = PhotosListViewModel(photosListInteractor: interactorMock, coordinator: coordinatorMock)
        
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        
        disposeBag = nil
        
        interactorMock = nil
        coordinatorMock = nil
        
        sut = nil
        
    }

    func testInit() {
        XCTAssertNotNil(interactorMock)
        XCTAssertNotNil(coordinatorMock)
        XCTAssertNotNil(sut)
    }

    func testViewDidLoad() {
        
    }
    
    func testFetchPhotosRefresh() {
        sut.fetchPhotos(refresh: true)
    }

    func testFetchPhotosFirstTime() {
        sut.fetchPhotos(refresh: false)
    }
    
    func testfetchRemotePhotos() {
        sut.fetchRemotePhotos(page: 1)
        XCTAssert
    }
    
    func testFetchCachedPhotos() {
        
    }
    
    func testIsBannerAdded() {
        
    }
    
    func testPhotoViewModelAtIndexPath() {
        
    }
    
    func testDidScroll() {
        
    }
    
    func testSearch() {
        
    }
    
    func testFetchSearch() {
        
    }
    
    func testDidImageDownloaded() {
        
    }
    
    func testRemoveCachedPhotos() {
        
    }
    
}
