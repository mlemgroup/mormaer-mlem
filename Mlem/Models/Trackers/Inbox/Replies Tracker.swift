//
//  Replies Tracker.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

@MainActor
class RepliesTracker: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var replies: [APICommentReplyView] = .init()
    // tracks the id of the 10th-from-last item so we know when to load more
    public var loadMarkId: Int = 0
    
    private var page: Int = 1
    
    func loadNextPage(account: SavedAccount) async throws {
        defer { isLoading = false }
        isLoading = true

        let newReplies = try await loadPage(account: account, page: page)

        guard !newReplies.isEmpty else {
            return
        }

        add(newReplies)
        page += 1
        loadMarkId = replies.count >= 40 ? replies[replies.count - 40].id : 0
    }
    
    func loadPage(account: SavedAccount, page: Int) async throws -> [APICommentReplyView] {
        let request = GetRepliesRequest(
            account: account,
            page: page,
            limit: 50
        )

        let response = try await APIClient().perform(request: request)

        return response.replies
    }
    
    func add(_ newReplies: [APICommentReplyView]) {
        // let accepted = newMentions.filter { ids.insert($0.id).inserted }
        replies.append(contentsOf: newReplies)
    }
    
    func refresh(account: SavedAccount) async throws {
        let newReplies = try await loadPage(account: account, page: 1)
        replies = newReplies
        page = 1
    }
}
