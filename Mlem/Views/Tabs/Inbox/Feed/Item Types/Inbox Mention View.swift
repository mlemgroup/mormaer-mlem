//
//  Inbox Mention View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

struct InboxMentionView: View {
    // let account: SavedAccount
    let mention: APIPersonMentionView
    
    let publishedAgo: String
    
    init(mention: APIPersonMentionView) {
        // self.account = account
        self.mention = mention
        
        self.publishedAgo = getTimeIntervalFromNow(date: mention.comment.published)
    }
    
    var body: some View {
        // TODO: tapping this should take you to the mention
        VStack {
            mentionHeader
            
            mentionBody
            
            Text(publishedAgo)
        }
    }
    
    @ViewBuilder
    var mentionHeader: some View {
        let creatorName: String = mention.creator.displayName ?? mention.creator.name
        // TODO: replace with comment header after that rework is done
        HStack() {
            // UserProfileLink(account: account, user: mention.creator)
            Text("\(creatorName) mentioned you:")
                .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
    
    @ViewBuilder
    var mentionBody: some View {
        MarkdownView(text: mention.comment.content)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .font(.subheadline)
    }
}
