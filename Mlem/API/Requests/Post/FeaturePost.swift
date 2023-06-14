//
//  FeaturePost.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

struct FeaturePostRequest: APIPostRequest {

    typealias Response = PostResponse

    let instanceURL: URL
    let path = "post/feature"
    let body: Body

    // lemmy_api_common::post::FeaturePost
    struct Body: Encodable {
        let post_id: Int
        let featured: Bool
        let feature_type: APIPostFeatureType

        let auth: String
    }

    init(
        account: SavedAccount,

        postId: Int,
        featured: Bool,
        featureType: APIPostFeatureType
    ) {
        self.instanceURL = account.instanceLink
        self.body = .init(
            post_id: postId,
            featured: featured,
            feature_type: featureType,

            auth: account.accessToken
        )
    }
}

