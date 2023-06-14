//
//  MarkPostAsRead.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct MarkPostAsReadRequest: APIPostRequest {

    typealias Response = PostResponse

    let instanceURL: URL
    let path = "post/mark_as_read"
    let body: Body

    // lemmy_api_common::post::MarkPostAsRead
    struct Body: Encodable {
        let postId: Int
        let read: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        postId: Int,
        read: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            postId: postId,
            read: read,

            auth: account.accessToken
        )
    }
}
