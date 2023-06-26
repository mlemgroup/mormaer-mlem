//
//  APIPersonMention.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

// lemmy_db_views_actor::structs::PersonMentionView
struct APIPersonMentionView: Decodable {
    let personMention: APIPersonMention
    let comment: APIComment
    let creator: APIPerson
    let post: APIPost
    let community: APICommunity
    let recipient: APIPerson
    let counts: APICommentAggregates
    let creatorBannedFromCommunity: Bool
    let subscribed: APISubscribedStatus
    let saved: Bool
    let creatorBlocked: Bool
    let myVote: ScoringOperation?
}

extension APIPersonMentionView: Identifiable {
    var id: Int { personMention.id }
}

extension APIPersonMentionView: Equatable {
    static func == (lhs: APIPersonMentionView, rhs: APIPersonMentionView) -> Bool {
        lhs.personMention == rhs.personMention
    }
}

extension APIPersonMentionView: Comparable {
    static func < (lhs: APIPersonMentionView, rhs: APIPersonMentionView) -> Bool {
        return lhs.comment.published < rhs.comment.published
    }
}

extension APIPersonMentionView: InboxItem {
    var type: InboxItemType { .mention }
    var content: String { self.comment.content }
    var published: Date { self.personMention.published }
}
