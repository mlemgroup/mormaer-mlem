//
//  RemoveComment.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

struct RemoveCommentRequest: APIPostRequest {

    typealias Response = CommentResponse

    let instanceURL: URL
    let path = "comment/remove"
    let body: Body

    // lemmy_api_common::comment::RemoveComment
    struct Body: Encodable {
        let commentId: Int
        let removed: Bool
        let reason: String?
        let auth: String
    }

    init(
        account: SavedAccount,
        commentId: Int,
        removed: Bool = true,
        reason: String? = nil
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            commentId: commentId,
            removed: removed,
            reason: reason,
            auth: account.accessToken
        )
    }
}

