//
//  SearchRequest.swift
//  Mlem
//
//  Created by Nicholas Lawson on 07/06/2023.
//

import Foundation

// lemmy_db_schema::SearchType
enum SearchType: String, Codable {
    case all = "All"
    case comments = "Comments"
    case communities = "Communities"
    case posts = "Posts"
    case url = "Url"
    case users = "Users"
}

struct SearchRequest: APIGetRequest {

    typealias Response = SearchResponse

    let instanceURL: URL
    let path = "search"
    let queryItems: [URLQueryItem]

    init(
        account: SavedAccount,
        query: String,
        searchType: SearchType,
        sortOption: SortingOptions = .topAll,
        listingType: FeedType = .all,
        page: Int? = nil,
        communityId: Int? = nil,
        communityName: String? = nil,
        creatorId: Int? = nil,
        limit: Int? = nil
    ) {
        self.instanceURL = account.instanceLink
        var queryItems: [URLQueryItem] = [
            .init(name: "auth", value: account.accessToken),
            .init(name: "type_", value: searchType.rawValue),
            .init(name: "sort", value: sortOption.rawValue),
            .init(name: "listing_type", value: listingType.rawValue),
            .init(name: "q", value: query)
        ]

        if let page {
            queryItems.append(
                .init(name: "page", value: "\(page)")
            )
        }

        if let communityId {
            queryItems.append(
                .init(name: "community_id", value: "\(communityId)")
            )
        }

        if let communityName {
            queryItems.append(
                .init(name: "community_name", value: "\(communityName)")
            )
        }

        if let creatorId {
            queryItems.append(
                .init(name: "creator_id", value: "\(creatorId)")
            )
        }

        if let limit {
            queryItems.append(
                .init(name: "limit", value: "\(limit)")
            )
        }

        self.queryItems = queryItems
    }
}

struct SearchResponse: Decodable {
    let comments: [APICommentView]
    let communities: [APICommunityView]
    let posts: [APIPostView]
    let type_: SearchType
    let users: [APIPersonView]
}
