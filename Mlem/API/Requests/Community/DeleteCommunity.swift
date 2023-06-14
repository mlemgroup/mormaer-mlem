//
//  DeleteCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct DeleteCommunityRequest: APIPostRequest {

    typealias Response = CommunityResponse

    let instanceURL: URL
    let path = "community/delete"
    let body: Body

    // lemmy_api_common::community::DeleteCommunity
    struct Body: Encodable {
        let communityId: Int
        let deleted: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        deleted: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            communityId: communityId,
            deleted: deleted,

            auth: account.accessToken
        )
    }
}
