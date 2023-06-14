//
//  LockPost.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct LockPostRequest: APIPostRequest {

    typealias Response = PostResponse

    let instanceURL: URL
    let path = "post/lock"
    let body: Body

    // lemmy_api_common::post::LockPost
    struct Body: Encodable {
        let postId: Int
        let locked: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        postId: Int,
        locked: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            postId: postId,
            locked: locked,

            auth: account.accessToken
        )
    }
}
