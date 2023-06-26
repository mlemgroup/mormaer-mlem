//
//  Inbox Item View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import SwiftUI

struct InboxItemView: View {
    let inboxItem: any InboxItem
    
    let publishedAgo: String
    
    init(inboxItem: any InboxItem) {
        self.inboxItem = inboxItem
        
        self.publishedAgo = String(getTimeIntervalFromNow(date: inboxItem.published))
    }
    
    var body: some View {
        VStack {
            Text(inboxItem.creator.displayName ?? inboxItem.creator.name)
            Text(inboxItem.content)
            Text(inboxItem.community.name)
            Text(publishedAgo)
            Divider()
        }
    }
}
