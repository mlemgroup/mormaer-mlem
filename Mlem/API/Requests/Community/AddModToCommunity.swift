//
//  AddModToCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct AddModToCommunityRequest: APIPostRequest {

    typealias Response = AddModToCommunityResponse

    let instanceURL: URL
    let path = "community/mod"
    let body: Body

    // lemmy_api_common::community::AddModToCommunity
    struct Body: Encodable {
        let communityId: Int
        let personId: Int
        let added: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        personId: Int,
        added: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            communityId: communityId,
            personId: personId,
            added: added,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::community::AddModToCommunityResponse
struct AddModToCommunityResponse: Decodable {
    let moderators: [APICommunityModeratorView]
}

