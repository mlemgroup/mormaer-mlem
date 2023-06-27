//
//  AllItemsView.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation
import SwiftUI

extension InboxView {
    @ViewBuilder
    func inboxFeedView() -> some View {
        Group {
            if allItems.isEmpty {
                noItemsView()
            }
            else {
                inboxListView()
            }
        }
        .padding(.horizontal)
        .task(priority: .userInitiated) {
            if mentionsTracker.mentions.isEmpty ||
                messagesTracker.messages.isEmpty ||
                repliesTracker.replies.isEmpty {
                print("Inbox tracker is empty")
                await loadFeed()
            }
            else {
                print("Inbox tracker is not empty")
            }
        }
    }
    
    @ViewBuilder
    func noItemsView() -> some View {
        if isLoading {
            LoadingView(whatIsLoading: .inbox)
        } else {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "text.bubble")
                
                Text("No items to be found")
            }
            .padding()
            .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    func inboxListView() -> some View {
        VStack {
            ForEach(allItems) { item in
                VStack {
                    switch(item.type) {
                    case .mention(let mention):
                        InboxMentionView(mention: mention)
                            .task {
                                // if !mentionsTracker.isLoading && item.id == mentionsTracker.loadMarkId {
                                if item.id == mentionsTracker.loadMarkId {
                                    await loadMentions()
                                }
                            }
                    case .message(let message):
                        InboxMessageView(message: message)
                            .task {
                                if !messagesTracker.isLoading && item.id == messagesTracker.loadMarkId {
                                    await loadMessages()
                                }
                            }
                    case .reply(let reply):
                        InboxReplyView(reply: reply)
                            .task {
                                if !repliesTracker.isLoading && item.id == repliesTracker.loadMarkId {
                                    await loadReplies()
                                }
                            }
                    }
                    Divider()
                }
            }
        }
    }
}
