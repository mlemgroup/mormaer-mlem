//
//  CreateCommentReport.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

struct CreateCommentReportRequest: APIPostRequest {

    typealias Response = CommentReportResponse

    let instanceURL: URL
    let path = "comment/report"
    let body: Body

    // lemmy_api_common::comment::CreateCommentReport
    struct Body: Encodable {
        let comment_id: Int
        let reason: String

        let auth: String
    }

    init(
        account: SavedAccount,

        commentId: Int,
        reason: String
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            comment_id: commentId,
            reason: reason,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::comment::CommentReportResponse
struct CommentReportResponse: Decodable {
    let commentReportView: APICommentReportView
}
