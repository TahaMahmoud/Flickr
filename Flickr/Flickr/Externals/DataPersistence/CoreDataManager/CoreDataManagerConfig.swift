//
//  CoreDataManagerConfig.swift
//  Flickr
//
//  Created by Taha on 19/05/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataManagerConfig {
    
    //As we know that container is set up in the AppDelegates so we need to refer that container.
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
    //We need to create a context from this container
    static let managedContext = appDelegate!.persistentContainer.viewContext
        
    //Now let’s create an entity and new user records.
    static let photosEntity = NSEntityDescription.entity(forEntityName: "PhotosData", in: managedContext)!
        
}
