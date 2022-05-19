//
//  PhotosListRequest.swift
//  Flickr
//
//  Created by Taha on 18/05/2022.
//

import Foundation
import Alamofire

enum PhotosListRequest: Endpoint {

    case fetchPhotos(page: Int, perPage: Int)
    case searchPhotos(searchText: String, page: Int, perPage: Int)

    var path: String {
        switch self {
        
        case .fetchPhotos:
            return ""
        case .searchPhotos:
            return ""
        }
    }
    
    var headers: HTTPHeaders {
        let headers = defaultHeaders
        return headers
    }

    var parameters: Parameters? {
        var param = defaultParams
        switch  self {
        case .fetchPhotos(let page, let perPage):
            param = ["method": "flickr.photos.getRecent",
                     "format": "json",
                     "nojsoncallback": 50,
                     "page": page,
                     "per_page": perPage,
                     "api_key": Constants.apiKey]
            
        case .searchPhotos(searchText: let searchText, page: let page, perPage: let perPage):
            param = ["method": "flickr.photos.search",
                     "format": "json",
                     "nojsoncallback": 50,
                     "text": searchText,
                     "page": page,
                     "per_page": perPage,
                     "api_key": Constants.apiKey]

        }

        return param
    }
    
    var method: HTTPMethod {
        switch self {

        case .fetchPhotos:
            return .get
            
        case .searchPhotos:
            return .get
        }
    }
}
