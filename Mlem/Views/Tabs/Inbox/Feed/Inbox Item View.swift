//
//  Inbox Item View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import SwiftUI

struct InboxItemView: View {
    let inboxItem: InboxItem
    
    let publishedAgo: String
    
    init(inboxItem: InboxItem) {
        self.inboxItem = inboxItem
        
        self.publishedAgo = String(getTimeIntervalFromNow(date: inboxItem.published))
    }
    
    var body: some View {
        switch(inboxItem.type) {
        case .mention(let inboxMention):
            InboxMentionView(mention: inboxMention)
        case .message(let message):
            InboxMessageView(message: message)
        }
    }
}
