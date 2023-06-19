//
//  Instance and Community List View.swift
//  Mlem
//
//  Created by David Bureš on 27.03.2022.
//
import AlertToast
import SwiftUI

struct AccountsPage: View
{
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var accountsTracker: SavedAccountTracker

    @State private var isShowingInstanceAdditionSheet: Bool = false

    @State private var showToast = false
    @State private var toast: AlertToast? = nil

    func accountNavigationBinding() -> Binding<Bool> {
        .init {
            accountsTracker.savedAccounts.count == 1
        } set: { _ in }
    }

    func guestAccountNavigationBinding() -> Binding<Bool> {
        .init {
            accountsTracker.savedAccounts.count == 0
        } set: { _ in }
    }

    var body: some View
    {
        NavigationStack
        {
            VStack
            {
                if !accountsTracker.savedAccounts.isEmpty
                {
                    List
                    {
                        ForEach(accountsTracker.savedAccounts)
                        { savedAccount in
                            NavigationLink
                            {
                                CommunityView(account: savedAccount, community: nil)
                                    .onAppear
                                    {
                                        appState.currentActiveAccount = savedAccount
                                    }
                            } label: {
                                HStack(alignment: .center)
                                {
                                    Text(savedAccount.username)
                                    Spacer()
                                    Text(savedAccount.instanceLink.host!)
                                        .foregroundColor(.secondary)
                                }
                                .minimumScaleFactor(0.01)
                                .lineLimit(1)
                            }
                        }
                        .onDelete(perform: deleteAccount)
                        .navigationDestination(isPresented: accountNavigationBinding(), destination: {
                            if let account = accountsTracker.savedAccounts.first {
                                CommunityView(account: account, community: nil)
                                    .onAppear
                                {
                                    appState.currentActiveAccount = account
                                }
                            }
                        })
                        NavigationLink
                        {
                            CommunityView(account: nil, community: nil)
                                .onAppear
                                {
                                    appState.currentActiveAccount = nil
                                }
                        } label: {
                            HStack(alignment: .center)
                            {
                                Text("Continue as Guest")
                                Spacer()
                                Text(DefaultLemmyServer.host!)
                                    .foregroundColor(.secondary)
                            }
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                        }
                    }
                    .toolbar
                    {
                        ToolbarItem(placement: .navigationBarLeading)
                        {
                            EditButton()
                        }
                    }
                }
                else
                {
                    VStack(alignment: .center, spacing: 15)
                    {
                        Text("You have no accounts added")
                            .foregroundColor(.secondary)
                        NavigationLink
                        {
                            CommunityView(account: nil, community: nil)
                        } label: {
                            Text("View Lemmy as a guest")

                        }
                    }
                }
            }
            .onAppear
            {
                appState.currentActiveAccount = nil
            }
            .navigationTitle("Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: guestAccountNavigationBinding(), destination: {
                CommunityView(account: nil, community: nil)
                    .onAppear
                {
                    appState.currentActiveAccount = nil
                }

            })
            .toolbar
            {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    Button
                    {
                        isShowingInstanceAdditionSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingInstanceAdditionSheet)
            {
                AddSavedInstanceView(isShowingSheet: $isShowingInstanceAdditionSheet)
            }
        }
        .alert(appState.alertTitle, isPresented: $appState.isShowingAlert)
        {
            Button(role: .cancel)
            {
                appState.isShowingAlert.toggle()
            } label: {
                Text("Close")
            }

        } message: {
            Text(appState.alertMessage)
        }
        .onAppear
        {
            print("Saved thing from keychain: \(String(describing: AppConstants.keychain["test"]))")
        }
        .toast(isPresenting: $showToast, duration: 2, tapToDismiss: true) {
            if let toast = toast {
                toast
            } else {
                AlertToast(type: .regular, title: "Message Missing!")
            }
        }
        .environment(\.displayToast, displayToast)
    }

    func displayToast(message: AlertToast) {
        toast = message
        showToast = true
    }

    internal func deleteAccount(at offsets: IndexSet)
    {
        for index in offsets
        {
            let savedAccountToRemove: SavedAccount = accountsTracker.savedAccounts[index]

            accountsTracker.savedAccounts.remove(at: index)

            // MARK: - Purge the account information from the Keychain

            AppConstants.keychain["\(savedAccountToRemove.id)_accessToken"] = nil
        }
    }
}
