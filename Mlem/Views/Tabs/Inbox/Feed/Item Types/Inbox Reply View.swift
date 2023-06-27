//
//  Inbox Reply View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

// /user/replies

struct InboxReplyView: View {
    let reply: APICommentReplyView
    let publishedAgo: String
    
    init(reply: APICommentReplyView) {
        self.reply = reply
        self.publishedAgo = String(getTimeIntervalFromNow(date: reply.commentReply.published))
    }
    
    var body: some View {
        Text("\(reply.creator.displayName ?? reply.creator.name) replied to your comment:")
        Text(reply.comment.content)
        Text(publishedAgo)
    }
}

