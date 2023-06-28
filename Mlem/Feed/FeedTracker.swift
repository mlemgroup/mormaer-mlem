// 
//  FeedTracker.swift
//  Mlem
//
//  Created by mormaer on 28/06/2023.
//  
//

import Foundation

@MainActor
class FeedTracker<Item: FeedItem>: ObservableObject {
    
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var items: [Item] = .init()
    
    private(set) var page: Int = 1
    
    private var ids: Set<Item.UniqueIdentifier> = .init()
    
    @discardableResult
    func perform<Request: APIRequest>(
        _ request: Request
    ) async throws -> Request.Response where Request.Response: FeedItemProviding, Request.Response.Item == Item {
        defer { isLoading = false }
        isLoading = true
        
        let response = try await APIClient().perform(request: request)
        
        add(response.items)
        page += 1
        
        return response
    }
    
    /// A method to add new items into the tracker, duplicate items will be rejected
    /// - Parameter newItems: The array of new `Item`'s you wish to add
    func add(_ newItems: [Item]) {
        let accepted = newItems.filter { ids.insert($0.uniqueIdentifier).inserted }
        items.append(contentsOf: accepted)
    }

    /// A method to add an item  to the start of the current list of items
    /// - Parameter newItem: The `Item` you wish to add
    func prepend(_ newItem: Item) {
        guard ids.insert(newItem.uniqueIdentifier).inserted else {
            return
        }

        items.prepend(newItem)
    }

    /// A method to supply an updated item to the tracker
    ///  - Note: If the `id` of the item is not already in the tracker the `updatedItem` will be discarded
    /// - Parameter updatedItem: An updated `Item`
    func update(with updatedItem: Item) {
        guard let index = items.firstIndex(where: { $0.uniqueIdentifier == updatedItem.uniqueIdentifier }) else {
            return
        }

        items[index] = updatedItem
    }
    
    /// A method to reset the tracker to it's initial state
    func reset() {
        ids = .init()
        page = 1
        items = .init()
    }
}
