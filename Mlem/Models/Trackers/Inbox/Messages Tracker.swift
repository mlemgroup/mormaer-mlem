//
//  Messages Tracker.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

@MainActor
class MessagesTracker: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var messages: [APIPrivateMessageView] = .init()
    // tracks the id of the 10th-from-last item so we know when to load more
    public var loadMarkId: Int = 0
    
    private var page: Int = 1
    
    func loadNextPage(account: SavedAccount) async throws {
        defer { isLoading = false }
        isLoading = true

        let request = GetPrivateMessagesRequest(
            account: account,
            page: page,
            limit: 50
        )

        let response = try await APIClient().perform(request: request)

        guard !response.privateMessages.isEmpty else {
            return
        }

        add(response.privateMessages)
        page += 1
        loadMarkId = messages.count >= 40 ? messages[messages.count - 40].id : 0
    }
    
    func add(_ newMessages: [APIPrivateMessageView]) {
        // let accepted = newMentions.filter { ids.insert($0.id).inserted }
        messages.append(contentsOf: newMessages)
    }
}
