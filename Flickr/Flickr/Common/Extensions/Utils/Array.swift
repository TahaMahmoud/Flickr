//
//  Array.swift
//  Flickr
//
//  Created by Taha on 19/05/2022.
//

import Foundation

extension Array {
    func chunks(of size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            let n = Swift.min(size, count - $0)
            return Array(self[$0 ..< $0 + n])
        }
    }
}
