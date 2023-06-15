//
//  TransferCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct TransferCommunityRequest: APIPostRequest {

    typealias Response = GetCommunityResponse

    let instanceURL: URL
    let path = "community/transfer"
    let body: Body

    // lemmy_api_common::community::TransferCommunity
    struct Body: Encodable {
        let community_id: Int
        let person_id: Int

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        personId: Int
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            community_id: communityId,
            person_id: personId,

            auth: account.accessToken
        )
    }
}
