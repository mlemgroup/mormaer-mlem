//
//  CreateCommunity.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct CreateCommunityRequest: APIPostRequest {

    typealias Response = CommunityResponse

    let instanceURL: URL
    let path = "community"
    let body: Body

    // lemmy_api_common::community::CreateCommunity
    struct Body: Encodable {
        let name: String
        let title: String
        let description: String?
        let icon: URL?
        let banner: URL?
        let nsfw: Bool?
        let posting_restricted_to_mods: Bool?
        let discussion_languages: [Int]?

        let auth: String
    }

    init(
        account: SavedAccount,

        name: String,
        title: String,
        description: String?,
        icon: URL?,
        banner: URL?,
        nsfw: Bool?,
        postingRestrictedToMods: Bool?,
        discussionLanguages: [Int]?
    ) {
        self.instanceURL = account.instanceLink

        self.body = .init(
            name: name,
            title: title,
            description: description,
            icon: icon,
            banner: banner,
            nsfw: nsfw,
            posting_restricted_to_mods: postingRestrictedToMods,
            discussion_languages: discussionLanguages,

            auth: account.accessToken
        )
    }
}
