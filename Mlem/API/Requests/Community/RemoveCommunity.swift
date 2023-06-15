//
//  RemoveCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct RemoveCommunityRequest: APIPostRequest {

    typealias Response = CommunityResponse

    let instanceURL: URL
    let path = "community/remove"
    let body: Body

    // lemmy_api_common::community::RemoveCommunity
    struct Body: Encodable {
        let community_id: Int
        let removed: Bool
        let reason: String?
        let expires: Int?

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        removed: Bool,
        reason: String?,
        expires: Int?
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            community_id: communityId,
            removed: removed,
            reason: reason,
            expires: expires,

            auth: account.accessToken
        )
    }
}
