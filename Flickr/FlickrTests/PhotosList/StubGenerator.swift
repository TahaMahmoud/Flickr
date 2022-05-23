//
//  StubGenerator.swift
//  FlickrTests
//
//  Created by Taha on 22/05/2022.
//

import Foundation
@testable import Flickr

class StubGenerator {

    var photos: [String] = ["http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg", "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg",         "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg",         "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg", "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg", "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg", "http://farm66.static.flickr.com/65535/52089549687_c80e5d9f78.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg", "http://farm66.static.flickr.com/65535/52089549422_7710270376.jpg"]
    
    func fetchRemotPhotos() -> PhotosListModel {
        let path = Bundle.main.path(forResource: "Photos", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let photos = try! decoder.decode(PhotosListModel.self, from: data)
        return photos
    }

    func fetchCachedPhotos() -> [String] {
        return photos
    }
}
