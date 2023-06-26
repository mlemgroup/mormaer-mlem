//
//  Inbox Tracker.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import Foundation

@MainActor
class InboxTracker: ObservableObject {
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var replies: [APICommentReplyView] = .init()
    
    // TODO: APIPersonMentionView
    // @Published private(set) var mentions: [APIPersonMentionView] = .init()
    
    // TODO: methods to get, update
    
    // TODO: thread together CommentReply, PersonMention, and 
}
