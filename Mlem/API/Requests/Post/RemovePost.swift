//
//  RemovePost.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct RemovePostRequest: APIPostRequest {

    typealias Response = PostResponse

    let instanceURL: URL
    let path = "post/remove"
    let body: Body

    // lemmy_api_common::post::RemovePost
    struct Body: Encodable {
        let post_id: Int
        let removed: Bool
        let reason: String?

        let auth: String
    }

    init(
        account: SavedAccount,

        postId: Int,
        removed: Bool,
        reason: String?
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            post_id: postId,
            removed: removed,
            reason: reason,

            auth: account.accessToken
        )
    }
}
