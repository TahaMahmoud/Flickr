//
//  PhotosListInteractor+CoreData.swift
//  Flickr
//
//  Created by Taha on 19/05/2022.
//

import RxSwift
import CoreData

extension PhotosListInteractor {
    
    func fetchCachedPhotos() -> Observable<[String]> {
        
        return Observable.create {[weak self] (observer) -> Disposable in

            do {

                let result = try self?.coreDataManager.managedContext.fetch((self?.coreDataManager.fetchPhotossRequest)!)
                
                for photosData in result as! [NSManagedObject] {
                    
                    let photoURL: String = photosData.value(forKey: "photoURL") as! String
                    
                    self?.cachedPhotos.append(photoURL)
                                    
                }
                                
                observer.onNext(self!.cachedPhotos)
                
            } catch {
                print("Error")
                observer.onNext([])
            }
            
            return Disposables.create()
        }

    }

    func savePhoto(photoURL: String) -> Observable<Bool> {
            
        let photo = NSManagedObject(entity: coreDataManager.photosEntity, insertInto: coreDataManager.managedContext)

        photo.setValue(photoURL, forKey: "photoURL")

        return Observable.create {[weak self] (observer) -> Disposable in
            if self?.coreDataManager.saveContext() == true {
                observer.onNext(true)
            }
            else {
                observer.onNext(false)
            }
            
            return Disposables.create()
        }

    }
    
    func removeAllPhotos() -> Observable<Bool> {
        
        let removeRequest = NSBatchDeleteRequest(fetchRequest: (self.coreDataManager.fetchPhotossRequest))
        
        return Observable.create {[weak self] (observer) -> Disposable in
            
            do {
                try self?.coreDataManager.managedContext.execute(removeRequest)
                
                if self?.coreDataManager.saveContext() == true {
                    observer.onNext(true)
                } else {
                    observer.onNext(false)
                }

            } catch {
                observer.onNext(false)
            }
            
            return Disposables.create()
        }
    }
    
}
