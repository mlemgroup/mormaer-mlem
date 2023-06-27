//
//  Inbox Feed View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

struct InboxFeedView: View {
    var account: SavedAccount
    
    @StateObject var mentionsTracker: MentionsTracker = .init()
    @StateObject var messagesTracker: MessagesTracker = .init()
    
    @State var isLoading: Bool = true
    @State var allItems: [InboxItem] = .init()
    
    var body: some View {
        ScrollView {
            if allItems.isEmpty {
                noItemsView
            }
            else {
                inboxListView
            }
        }
        .padding(.horizontal)
        .task(priority: .userInitiated) {
            if mentionsTracker.mentions.isEmpty {
                print("Inbox tracker is empty")
                await loadFeed()
            }
            else {
                print("Inbox tracker is not empty")
            }
        }
    }
    
    @ViewBuilder
    private var noItemsView: some View {
        if isLoading {
            LoadingView(whatIsLoading: .inbox)
        } else {
            VStack(alignment: .center, spacing: 5) {
                Image(systemName: "text.bubble")

                Text("No items to be found")
            }
            .padding()
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var inboxListView: some View {
        VStack {
            ForEach(allItems) { item in
                VStack {
                    switch(item.type) {
                    case .mention(let mention):
                        InboxMentionView(mention: mention)
                            .task {
                                if !mentionsTracker.isLoading && item.id == mentionsTracker.loadMarkId {
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
                    }
                    Divider()
                }
            }
        }
    }
}
