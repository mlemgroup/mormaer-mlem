//
//  GetPostsRequest.swift
//  Mlem
//
//  Created by Nicholas Lawson on 07/06/2023.
//

import Foundation

struct GetPostsRequest: APIGetRequest {

    typealias Response = GetPostsResponse

    let instanceURL: URL
    let path = "post/list"
    let queryItems: [URLQueryItem]

    // lemmy_api_common::post::GetPosts
    // TODO add community_name
    init(
        account: SavedAccount,
        communityId: Int?,
        page: Int,
        sort: SortingOptions?,
        type: FeedType = .all,
        limit: Int? = nil,
        savedOnly: Bool? = nil
    ) {
        self.instanceURL = account.instanceLink

        var queryItems: [URLQueryItem] = [
            .init(name: "auth", value: account.accessToken),
            .init(name: "page", value: "\(page)"),
            .init(name: "type_", value: type.rawValue)
        ]

        if let sort {
            queryItems.append(
                .init(name: "sort", value: sort.rawValue)
            )
        }

        if let communityId {
            queryItems.append(
                .init(name: "community_id", value: "\(communityId)")
            )
        }

        if let limit {
            queryItems.append(
                .init(name: "limit", value: "\(limit)")
            )
        }

        if let savedOnly {
            queryItems.append(
                .init(name: "saved_only", value: "\(savedOnly)")
            )
        }

        self.queryItems = queryItems
    }
}

// lemmy_api_common::post::GetPostsResponse
struct GetPostsResponse: Decodable {
    let posts: [APIPostView]
}
