//
//  ContentView.swift
//  Mlem
//
//  Created by David Bureš on 25.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var urlToDisplay: URL?
    
    var body: some View
    {
        TabView
        {
            AccountsPage()
                .tabItem
                {
                    Label("Feeds", systemImage: "text.bubble")
                }
            
            SettingsView()
                .tabItem
                {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear
        {
            AppConstants.keychain["test"] = "I-am-a-saved-thing"
        }
        .environment(\.openURL, OpenURLAction(handler: handleURL))
        .sheet(item: $urlToDisplay) { SafariView(url: $0) }
    }
    
    private func handleURL(_ url: URL) -> OpenURLAction.Result {
        #warning("TODO: consider how we might deep link within the application for urls such as '/c/<community_name>' and '/post/<post_id>'")
        urlToDisplay = url
        return .handled
    }
}
