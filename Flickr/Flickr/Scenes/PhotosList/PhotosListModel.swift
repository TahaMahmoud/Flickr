//
//  PhotosListModel.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation

// MARK: - PhotosListModel
struct PhotosListModel: Codable {
    let photos: Photos?
    let stat: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int?
    let photo: [Photo]?
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String?
    let farm: Int?
    let title: String?
    let ispublic, isfriend, isfamily: Int?
}
