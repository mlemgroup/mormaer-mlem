//
//  Inbox Item.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

/**
 Protocol for items in the inbox to allow a unified, sorted feed
 */
protocol InboxItem: Comparable, Identifiable {
    var type: InboxItemType { get }
    var creator: APIPerson { get }
    var content: String { get }
    var community: APICommunity { get }
    var published: Date { get }
    
    var id: Int { get }
}
