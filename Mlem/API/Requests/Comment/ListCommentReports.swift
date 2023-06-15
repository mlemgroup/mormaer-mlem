//
//  ListCommentReports.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

// lemmy_api_common::comment::ListCommentReports
struct ListCommentReportsRequest: APIGetRequest {

    typealias Response = ListCommentReportsResponse

    let instanceURL: URL
    let path = "comment/report/list"
    let queryItems: [URLQueryItem]

    init(
        account: SavedAccount,

        communityId: Int?,
        page: Int? = nil,
        limit: Int? = nil,
        unresolvedOnly: Bool = true
    ) {
        self.instanceURL = account.instanceLink
        self.queryItems = [
            .init(name: "community_id", value: communityId?.description),
            .init(name: "page", value: page?.description),
            .init(name: "limit", value: limit?.description),
            .init(name: "unresolved_only", value: String(unresolvedOnly)),

            .init(name: "auth", value: account.accessToken),
        ]
    }
}

// lemmy_api_common::comment::ListCommentReportsResponse
struct ListCommentReportsResponse: Decodable {
    let commentReports: [APICommentReportView]
}
