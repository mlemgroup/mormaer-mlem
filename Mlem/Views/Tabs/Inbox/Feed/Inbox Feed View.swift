//
//  Inbox Feed View.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-25.
//

import SwiftUI

struct InboxFeedView: View {
    @State var account: SavedAccount
    @StateObject var mentionsTracker: MentionsTracker = .init()
    
    @State var allPosts: [any InboxItem] = .init()
    
    var body: some View {
        ScrollView {
            if mentionsTracker.mentions.isEmpty {
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
        if mentionsTracker.isLoading { // TODO: or this with all other things to load
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
        ForEach(allPosts, id: \.id) { item in
            InboxItemView(inboxItem: item)
        }
//        ForEach(mentionsTracker.mentions) { item in
//            InboxMentionView(account: account, mention: item)
//            .buttonStyle(EmptyButtonStyle()) // Make it so that the link doesn't mess with the styling
//            .task {
//                if !mentionsTracker.isLoading {
//                    if let position = mentionsTracker.mentions.lastIndex(of: item) {
//                        if  position >= (mentionsTracker.mentions.count - 40) {
//                            print("time to load some more")
//                            // await loadFeed()
//                        }
//                    }
//                }
//            }
//        }
    }
}
