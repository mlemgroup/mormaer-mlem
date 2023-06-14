//
//  CreatePostReport.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct CreatePostReportRequest: APIPostRequest {

    typealias Response = PostReportResponse

    let instanceURL: URL
    let path = "post/report"
    let body: Body

    // lemmy_api_common::post::CreatePostReport
    struct Body: Encodable {
        let postId: Int
        let reason: String

        let auth: String
    }

    init(
        account: SavedAccount,

        postId: Int,
        reason: String
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            postId: postId,
            reason: reason,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::post::PostReportResponse
struct PostReportResponse: Decodable {
    let postReportView: APIPostReportView
}
