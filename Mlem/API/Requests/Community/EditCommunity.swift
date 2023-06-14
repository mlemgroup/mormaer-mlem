//
//  EditCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct EditCommunityRequest: APIPutRequest {

    typealias Response = CommunityResponse

    let instanceURL: URL
    let path = "community"
    let body: Body

    // lemmy_api_common::community::EditCommunity
    struct Body: Encodable {
        let communityId: Int

        let title: String?
        let description: String?
        let icon: URL?
        let banner: URL?
        let nsfw: Bool?
        let postingRestrictedToMods: Bool?
        let discussionLanguages: [Int]?

        let auth: String
    }

    init(
        account: SavedAccount,

        communityId: Int,
        title: String?,
        description: String?,
        icon: URL?,
        banner: URL?,
        nsfw: Bool?,
        postingRestrictedToMods: Bool?,
        discussionLanguages: [Int]?
    ) {
        self.instanceURL = account.instanceLink

        self.body = .init(
            communityId: communityId,
            title: title,
            description: description,
            icon: icon,
            banner: banner,
            nsfw: nsfw,
            postingRestrictedToMods: postingRestrictedToMods,
            discussionLanguages: discussionLanguages,

            auth: account.accessToken
        )
    }
}
