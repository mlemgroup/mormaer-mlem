//
//  ResolvePostReport.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct ResolvePostReportRequest: APIPutRequest {

    typealias Response = PostReportResponse

    let instanceURL: URL
    let path = "post/report/resolve"
    let body: Body

    // lemmy_api_common::post::ResolvePostReport
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
