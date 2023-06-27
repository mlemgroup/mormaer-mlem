//
//  MentionsTracker.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

@MainActor
class MentionsTracker: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var mentions: [APIPersonMentionView] = .init()
    public var loadMarkId: Int = 0
    
    private var page: Int = 1
    
    func loadNextPage(account: SavedAccount, sort: SortingOptions?) async throws {
        defer { isLoading = false }
        isLoading = true

        let request = GetPersonMentionsRequest(
            account: account,
            sort: sort,
            page: page,
            limit: 50
        )

        let response = try await APIClient().perform(request: request)

        guard !response.mentions.isEmpty else {
            return
        }

        add(response.mentions)
        page += 1
        loadMarkId = mentions.count >= 40 ? mentions[mentions.count - 40].personMention.id : 0
    }
    
    func add(_ newMentions: [APIPersonMentionView]) {
        // let accepted = newMentions.filter { ids.insert($0.id).inserted }
        mentions.append(contentsOf: newMentions)
    }
}
