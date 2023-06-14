//
//  APIPostReport.swift
//  Mlem
//
//  Created by Nicholas Lawson on 09/06/2023.
//

import Foundation

// lemmy_db_schema::source::post_report::PostReport
struct APIPostReport: Decodable {
    let id: Int
    let creatorId: Int
    let postId: Int
    let originalPostName: String
    let originalPostUrl: URL?
    let originalPostBody: String?
    let reason: String
    let resolved: Bool
    let resolverId: Int?
    let published: Date
    let updated: Date?
}
