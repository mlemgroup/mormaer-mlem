// 
//  FeedItemProviding.swift
//  Mlem
//
//  Created by mormaer on 28/06/2023.
//  
//

import Foundation

protocol FeedItemProviding {
    associatedtype Item: FeedItem
    var items: [Item] { get }
}

protocol FeedItem: Decodable {
    associatedtype UniqueIdentifier: Hashable
    var uniqueIdentifier: UniqueIdentifier { get }
}
