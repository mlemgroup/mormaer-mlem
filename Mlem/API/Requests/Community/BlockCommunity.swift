//
//  BlockCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct BlockCommunityRequest: APIPostRequest {

    typealias Response = BlockCommunityResponse

    let instanceURL: URL
    let path = "community/block"
    let body: Body

    // lemmy_api_common::community::BlockCommunity
    // swiftlint:disable identifier_name
    struct Body: Encodable {
        let community_id: Int
        let block: Bool

        let auth: String
    }
    // swiftlint:enable identifier_name

    init(
        account: SavedAccount,

        communityId: Int,
        block: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            community_id: communityId,
            block: block,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::community::BlockCommunityResponse
struct BlockCommunityResponse: Decodable {
    let communityView: APICommunityView
    let blocked: Bool
}
