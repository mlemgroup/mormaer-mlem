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
        let community_id: Int
        let person_id: Int
        let ban: Bool
        let remove_data: Bool?
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
            community_id: communityId,
            person_id: personId,
            ban: ban,
            remove_data: removeData,
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

