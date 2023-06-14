//
//  APIPostFeatureType.swift
//  Mlem
//
//  Created by Jonathan de Jong on 13/06/2023.
//

import Foundation

// lemmy_db_schema::PostFeatureType
enum APIPostFeatureType: String, Encodable {
    case local = "Local"
    case community = "Community"
}
