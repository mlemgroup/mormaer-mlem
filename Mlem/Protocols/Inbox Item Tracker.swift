//
//  Inbox Item Tracker.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

protocol InboxItemTracker {
    var loadMarkId: Int { get }
    func getInboxItems() -> [InboxItem]
}
