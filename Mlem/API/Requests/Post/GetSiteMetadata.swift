//
//  GetSiteMetadata.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13.06.2023.
//

import Foundation

// lemmy_api_common::post::GetSiteMetadata
struct GetSiteMetadataRequest: APIGetRequest {

    typealias Response = GetSiteMetadataResponse

    let instanceURL: URL
    let path = "post/site_metadata"
    let queryItems: [URLQueryItem]

    init(
        instanceURL: URL,
        
        url: URL
    ) {
        self.instanceURL = instanceURL
        self.queryItems = [
            .init(name: "url", value: url.absoluteString)
        ]
    }
}

// lemmy_api_common::post::GetSiteMetadataResponse
struct GetSiteMetadataResponse: Decodable {
    let title: String?
    let description: String?
    let image: URL?
    let embedVideoUrl: URL?
}

