//
//  User Moderator View.swift
//  Mlem
//
//  Created by Jake Shirley on 6/30/23.
//

import CachedAsyncImage
import SwiftUI

struct UserModeratorView: View {
    // parameters
    let account: SavedAccount
    @State var userDetails: APIPersonView
    @State var moderatedCommunities: [APICommunityModeratorView]
    
    var body: some View {
        List {
            ForEach(moderatedCommunities) { community in
                HStack {
                    CommunityLinkView(community: community.community)
                    Spacer()
                }
            }
        }
        .navigationTitle("Moderator Details")
        .navigationBarTitleDisplayMode(.inline)
        .headerProminence(.standard)
        .listStyle(.plain)
    }
}
