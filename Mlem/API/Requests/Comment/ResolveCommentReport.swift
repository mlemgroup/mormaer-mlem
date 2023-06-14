//
//  ResolveCommentReport.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

struct ResolveCommentReportRequest: APIPutRequest {

    typealias Response = CommentReportResponse

    let instanceURL: URL
    let path = "comment/report/resolve"
    let body: Body

    // lemmy_api_common::comment::ResolveCommentReport
    struct Body: Encodable {
        let reportId: Int
        let resolved: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        reportId: Int,
        resolved: Bool
    ) {
        self.instanceURL = account.instanceLink

        self.body = .init(
            reportId: reportId,
            resolved: resolved,

            auth: account.accessToken
        )
    }
}
