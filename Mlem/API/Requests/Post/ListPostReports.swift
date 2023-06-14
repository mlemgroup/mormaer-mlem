//
//  ListPostReports.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

// lemmy_api_common::post::ListPostReports
struct ListPostReportsRequest: APIGetRequest {

    typealias Response = ListPostReportsResponse

    let instanceURL: URL
    let path = "post/report/list"
    let queryItems: [URLQueryItem]

    init(
        account: SavedAccount,

        communityId: Int?,
        unresolvedOnly: Bool?,
        page: Int?,
        limit: Int?
    ) {
        self.instanceURL = account.instanceLink
        self.queryItems = [
            .init(name: "page", value: page?.description),
            .init(name: "limit", value: limit?.description),
            .init(name: "community_id", value: communityId?.description),
            .init(name: "unresolved_only", value: unresolvedOnly.map(String.init)),

            .init(name: "auth", value: account.accessToken),
        ]
    }
}

// lemmy_api_common::post::ListPostReportsResponse
struct ListPostReportsResponse: Decodable {
    let postReports: [APIPostReportView]
}
