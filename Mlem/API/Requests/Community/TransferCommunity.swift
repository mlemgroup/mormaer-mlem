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
        let communityId: Int
        let personId: Int

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        personId: Int
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            communityId: communityId,
            personId: personId,

            auth: account.accessToken
        )
    }
}
