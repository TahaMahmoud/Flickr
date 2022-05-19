//
//  PhotoCellViewModel.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation

class PhotoCellViewModel  {
    
    var photoURL: String?
    var isAdBanner: Bool
    
    init(photoURL: String, isAdBanner: Bool) {
        self.photoURL = photoURL
        self.isAdBanner = isAdBanner
    }
    
}
