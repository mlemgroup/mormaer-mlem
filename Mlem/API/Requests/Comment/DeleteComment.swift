//
//  DeleteComment.swift
//  Mlem
//
//  Created by Nicholas Lawson on 08/06/2023.
//

import Foundation

struct DeleteCommentRequest: APIPostRequest {

    typealias Response = CommentResponse

    let instanceURL: URL
    let path = "comment/delete"
    let body: Body

    // lemmy_api_common::comment::DeleteComment
    // swiftlint:disable identifier_name
    struct Body: Encodable {
        let comment_id: Int
        let deleted: Bool
        let auth: String
    }
    // swiftlint:enable identifier_name

    init(
        account: SavedAccount,
        commentId: Int,
        deleted: Bool = true
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            comment_id: commentId,
            deleted: deleted,
            auth: account.accessToken
        )
    }
}
