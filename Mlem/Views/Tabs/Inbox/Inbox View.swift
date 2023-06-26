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

class PrivateMessageThread: Identifiable {
    let account: SavedAccount
    let recipient: APIPerson
    var messages: [APIPrivateMessageView]
    var id: Int { recipient.id }
    
    init(account: SavedAccount, recipient: APIPerson, messages: [APIPrivateMessageView]) {
        self.account = account
        self.recipient = recipient
        self.messages = messages
    }
    
    func addMessage(_ message: APIPrivateMessageView) {
        messages.append(message)
        messages.sort(by: { $0.privateMessage.published < $1.privateMessage.published})
    }
}

struct PrivateMessageContentView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color.secondarySystemBackground)
            .cornerRadius(10)
    }
}

struct PrivateMessageView : View {
    var currentMessage: APIPrivateMessageView
    var isCurrentUser: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if isCurrentUser {
                if let avatarUrl = currentMessage.creator.avatar {
                    CachedAsyncImage(url: avatarUrl, urlCache: AppConstants.urlCache)
                    { image in
                        image
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .cornerRadius(20)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                } else {
                    Spacer()
                }
            } else {
                Spacer()
            }
            PrivateMessageContentView(contentMessage: currentMessage.privateMessage.content,
                               isCurrentUser: isCurrentUser)
        }
    }
}

struct PrivateMessageThreadView: View {
    @State var privateMessageThread: PrivateMessageThread
    
    var body: some View {
        VStack {
            List {
                ForEach(privateMessageThread.messages) {
                    privateMessage in
                    
                    PrivateMessageView(currentMessage: privateMessage, isCurrentUser: privateMessage.creator != privateMessageThread.recipient)
                }
            }.listRowSeparator(.hidden)
                .listStyle(GroupedListStyle())
        }.navigationTitle("PM with \(privateMessageThread.recipient.displayName ?? privateMessageThread.recipient.name)").border(.red)
    }
}

struct InboxView: View {
    
    @State var account: SavedAccount
    
    @State private var selectionSection = 0
    @State private var privateMessageThreads: [PrivateMessageThread] = []
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                VStack {
                    Picker(selection: $selectionSection, label: Text("Profile Section")) {
                        Text("All").tag(0)
                        Text("Replies").tag(1)
                        Text("Messages").tag(2)
                        Text("Mentions").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    if selectionSection == 2 {
                        ForEach(privateMessageThreads) { privatgeMessageThread in
                            
                            NavigationLink(destination: PrivateMessageThreadView(privateMessageThread: privatgeMessageThread)) {
                                Text("PM with \(privatgeMessageThread.recipient.name)")
                            }
                        }
                    }
                    
                    Spacer()
                }
            } .navigationTitle("Inbox")
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(PlainListStyle())
        }.task {
            await fetchUserNotifications()
        }
    }
    
    // Note: Does not currently handle refresh, data will be duplicated!
    private func fetchUserNotifications() async {
        do {
            let request = try GetPrivateMessagesRequest(
                account: account,
                page: 1,
                limit: 50
            )
            
            let apiResponse = try await APIClient().perform(request: request)
            
            for message in apiResponse.privateMessages {
                // Get the other users ID as that's how we key PM threads
                var otherUser = message.creator
                if otherUser.id == account.id {
                    otherUser = message.recipient
                }
                
                if let existingThread = privateMessageThreads.first(where: {$0.recipient == otherUser}) {
                    existingThread.addMessage(message)
                } else {
                    privateMessageThreads.append(PrivateMessageThread(account: account, recipient: otherUser, messages: [message])
                    )
                }
            }
        } catch {
            print("Fetch user PMs error: \(error)")
        }
    }
    
}



struct InboxViewPreview: PreviewProvider {
    static private let previewAccount = SavedAccount(id: 0, instanceLink: URL(string: "lemmy.com")!, accessToken: "abcdefg", username: "Test Account")
    
    static var previews: some View {
        InboxView(account: InboxViewPreview.previewAccount)
    }
}
    
