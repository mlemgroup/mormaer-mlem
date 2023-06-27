//
//  Inbox.swift
//  Mlem
//
//  Created by Jake Shirley on 6/25/23.
//

import Foundation
import SwiftUI
import CachedAsyncImage

enum InboxTab {
    case all, replies, messages, mentions
}

// NOTE:
// all of the subordinate views are defined as functions in extensions because otherwise the tracker logic gets *ugly*

// TODO:
// - efficient aggregation
// - only refresh active page
// - make purdy

struct InboxView: View {
    @State var account: SavedAccount
    
    @State var isLoading: Bool = true
    @State var allItems: [InboxItem] = .init()
    
    @StateObject var mentionsTracker: MentionsTracker = .init()
    @StateObject var messagesTracker: MessagesTracker = .init()
    @StateObject var repliesTracker: RepliesTracker = .init()
    
    @State private var selectionSection = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Picker(selection: $selectionSection, label: Text("Profile Section")) {
                        Text("All").tag(0)
                        Text("Replies").tag(1)
                        Text("Mentions").tag(2)
                        Text("Messages").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    switch selectionSection {
                    case 0:
                        inboxFeedView()
                    case 1:
                        repliesFeedView()
                    case 2:
                        mentionsFeedView()
                    case 3:
                        messagesFeedView()
                    default:
                        Text("screaming")
                    }
                    
                    Spacer()
                }
            }
            .refreshable {
                Task(priority: .userInitiated) {
                    await loadFeed()
                }
            }
            .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle())
        }
    }
    
    // Note: Does not currently handle refresh, data will be duplicated!
//    private func fetchUserNotifications() async {
//        do {
//            let request = try GetPrivateMessagesRequest(
//                account: account,
//                page: 1,
//                limit: 50
//            )
//
//            let apiResponse = try await APIClient().perform(request: request)
//
//            for message in apiResponse.privateMessages {
//                // Get the other users ID as that's how we key PM threads
//                var otherUser = message.creator
//                if otherUser.id == account.id {
//                    otherUser = message.recipient
//                }
//
//                if let existingThread = privateMessageThreads.first(where: {$0.recipient == otherUser}) {
//                    existingThread.addMessage(message)
//                } else {
//                    privateMessageThreads.append(PrivateMessageThread(account: account, recipient: otherUser, messages: [message])
//                    )
//                }
//            }
//        } catch {
//            print("Fetch user PMs error: \(error)")
//        }
//    }
    
}



struct InboxViewPreview: PreviewProvider {
    static private let previewAccount = SavedAccount(id: 0, instanceLink: URL(string: "lemmy.com")!, accessToken: "abcdefg", username: "Test Account")
    
    static var previews: some View {
        InboxView(account: InboxViewPreview.previewAccount)
    }
}
    
