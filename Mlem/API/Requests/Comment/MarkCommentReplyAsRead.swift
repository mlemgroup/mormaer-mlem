//
//  MarkCommentReplyAsRead.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

struct MarkCommentReplyAsReadRequest: APIPostRequest {

    typealias Response = CommentReplyResponse

    let instanceURL: URL
    let path = "comment/mark_as_read"
    let body: Body

    // lemmy_api_common::person::MarkCommentReplyAsRead
    struct Body: Encodable {
        let comment_reply_id: Int
        let read: Bool

        let auth: String
    }

    init(
        account: SavedAccount,

        commentReplyId: Int,
        read: Bool
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            comment_reply_id: commentReplyId,
            read: read,

            auth: account.accessToken
        )
    }
}

// lemmy_api_common::person::CommentReplyResponse
struct CommentReplyResponse: Decodable {
    let commentReplyView: APICommentReplyView
}
