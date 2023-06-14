//
//  APICommentReportView.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

// lemmy_db_views::structs::CommentReportView
struct APICommentReportView: Decodable {
    let commentReport: APICommentReport
    let comment: APIComment
    let post: APIPost
    let community: APICommunity
    let creator: APIPerson
    let commentCreator: APIPerson
    let creatorBannedFromCommunity: Bool
    let myVote: Int?
    let resolver: APIPerson?
}
