//
//  Inbox Message View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

// /private_message/list

struct InboxMessageView: View {
    let message: APIPrivateMessageView
    let publishedAgo: String
    
    init(message: APIPrivateMessageView) {
        self.message = message
        
        self.publishedAgo = getTimeIntervalFromNow(date: message.privateMessage.published)
    }
    
    var body: some View {
        Text("\(message.creator.displayName ?? message.creator.name) messaged you:")
        Text(message.privateMessage.content)
        Text(publishedAgo)
    }
}
