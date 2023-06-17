//
//  Infinite loader.swift
//  Mlem
//
//  Created by David Bureš on 18.06.2022.
//

import Foundation
import SwiftUI

@MainActor
func loadInfiniteFeed(
    postTracker: PostTracker,
    appState: AppState,
    communityId: Int?,
    feedType: FeedType,
    sortingType: SortingOptions,
    account: SavedAccount
) async throws {
    print("Page counter value: \(postTracker.page)")
    let request = GetPostsRequest(
        account: account,
        communityId: communityId,
        page: postTracker.page,
        sort: sortingType,
        type: feedType
    )
    
    let response = try await APIClient().perform(request: request)
    
    guard !response.posts.isEmpty else {
        return
    }
    
    postTracker.add(response.posts)
    postTracker.page += 1
}
