//
//  BanFromCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct BanFromCommunityRequest: APIPostRequest {

    typealias Response = BanFromCommunityResponse

    let instanceURL: URL
    let path = "community/ban_user"
    let body: Body

    // lemmy_api_common::community::BanFromCommunity
    struct Body: Encodable {
        let communityId: Int
        let personId: Int
        let ban: Bool
        let removeData: Bool?
        let reason: String?
        let expires: Int?

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        personId: Int,
        ban: Bool,
        removeData: Bool?,
        reason: String?,
        expires: Int?
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            communityId: communityId,
            personId: personId,
            ban: ban,
            removeData: removeData,
            reason: reason,
            expires: expires,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::community::BanFromCommunityResponse
struct BanFromCommunityResponse: Decodable {
    let personView: APIPersonView
    let banned: Bool
}

