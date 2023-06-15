//
//  APICommentReport.swift
//  Mlem
//
//  Created by Jonathan de Jong on 14.06.2023.
//

import Foundation

// lemmy_db_schema::source::comment_report::CommentReport
struct APICommentReport: Decodable {
    let id: Int
    let creatorId: Int
    let commentId: Int
    let originalCommentText: String
    let reason: String
    let resolved: Bool
    let resolverId: Int?
    let published: Date
    let updated: Date?
}
