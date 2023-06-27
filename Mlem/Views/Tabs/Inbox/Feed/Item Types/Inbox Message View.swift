//
//  Inbox Message View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

// /private_message/list

struct InboxMessageView: View {
    let account: SavedAccount
    let message: APIPrivateMessageView
    let publishedAgo: String
    
    init(account: SavedAccount, message: APIPrivateMessageView) {
        self.account = account
        self.message = message
        
        self.publishedAgo = getTimeIntervalFromNow(date: message.privateMessage.published)
    }
    
    var body: some View {
        //UserProfileLink(account: account, user: message.creator)
        UserProfileLink(account: account, user: message.creator, showServerInstance: true)
        Text(message.privateMessage.content)
        Text(publishedAgo)
    }
}
