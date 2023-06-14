//
//  APIPostReportView.swift
//  Mlem
//
//  Created by Nicholas Lawson on 09/06/2023.
//

import Foundation

// lemmy_db_views::structs::PostReportView
struct APIPostReportView: Decodable {
    let postReport: APIPostReport
    let post: APIPost
    let community: APICommunity
    let creator: APIPerson
    let postCreator: APIPerson
    let creatorBannedFromCommunity: Bool
    let myVote: Int?
    let counts: APIPostAggregates
    let resolver: APIPerson?
}
