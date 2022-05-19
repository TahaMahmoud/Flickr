//
//  CoreDataManager.swift
//  Flickr
//
//  Created by Taha on 19/05/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var managedContext: NSManagedObjectContext
    var photosEntity: NSEntityDescription
    
    //Prepare the request of type NSFetchRequest  for the entity
    let fetchPhotosRequest: NSFetchRequest<NSFetchRequestResult>
        
    init() {
        self.managedContext = CoreDataManagerConfig.managedContext
        self.photosEntity = CoreDataManagerConfig.photosEntity
        self.fetchPhotosRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PhotosData")
    }
    
    func saveContext() -> Bool {
        do {
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
}
