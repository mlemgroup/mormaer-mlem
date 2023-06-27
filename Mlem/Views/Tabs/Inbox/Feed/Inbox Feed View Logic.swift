//
//  Inbox Feed View Logic.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-26.
//

import Foundation

extension InboxFeedView {
    func loadFeed() async {
        do {
            try await mentionsTracker.loadNextPage(account: account, sort: SortingOptions.new)
            try await messagesTracker.loadNextPage(account: account)
            
            aggregateAllTrackers()
        } catch APIClientError.networking {
            // TODO: we're seeing a number of SSL related errors on some instances while loading pages from the feed
            // while we investigate the reasons we will only show this error if the user would otherwise be left with an empty feed
            guard mentionsTracker.mentions.isEmpty else {
                print("nothing doing")
                return
            }
            
//            errorAlert = .init(
//                title: "Unable to connect to Lemmy",
//                message: "Please check your internet connection and try again"
//            )
        } catch APIClientError.response(let message, _) {
            print(message)
            print("APIClientError")
//            errorAlert = .init(
//                title: "Error",
//                message: message.error
//            )
        } catch APIClientError.cancelled {
            print("Failed while loading feed (request cancelled)")
        } catch(let message) {
            print(message)
            // TODO: we may be receiving decoding errors (or something else) based on reports in the dev chat
            // for now we will fail silently if the user has posts to view while we investigate further
            assertionFailure("Unhandled error encountered, if you can reproduce this please raise a ticket/discuss in the dev chat")
            // errorAlert = .unexpected
        }

    }
    
    func loadMentions() async {
        do {
            try await mentionsTracker.loadNextPage(account: account, sort: SortingOptions.new)
            aggregateAllTrackers()
            // TODO: make that call above return the new items and do a nice neat merge sort that doesn't re-sort the whole damn array
        } catch(let message) {
            print(message)
        }
    }
    
    func loadMessages() async {
        do {
            try await messagesTracker.loadNextPage(account: account)
            aggregateAllTrackers()
        } catch(let message) {
            print(message)
        }
    }
    
    func aggregateAllTrackers() {
        let mentions = mentionsTracker.mentions.map { item in
            InboxItem(published: item.personMention.published, id: item.personMention.id, type: .mention(item))
        }
        
        let messages = messagesTracker.messages.map { item in
            InboxItem(published: item.privateMessage.published, id: item.id, type: .message(item))
        }
        
        allItems = (mentions + messages).sorted(by: >)
    }
}
