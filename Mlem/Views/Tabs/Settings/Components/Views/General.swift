//
//  General.swift
//  Mlem
//
//  Created by David Bureš on 19.05.2023.
//

import SwiftUI

internal enum FavoritesPurgingError
{
    case failedToDeleteOldFavoritesFile, failedToCreateNewEmptyFile
}

struct GeneralSettingsView: View
{
    @AppStorage("defaultCommentSorting") var defaultCommentSorting: CommentSortTypes = .top
    
    @AppStorage("defaultFeed") var defaultFeed: FeedType = .subscribed
    
    @EnvironmentObject var favoritesTracker: FavoriteCommunitiesTracker
    @EnvironmentObject var appState: AppState

    @State private var isShowingFavoritesDeletionConfirmation: Bool = false
    @State private var isShowingResetDefaultsConfirmation: Bool = false
    
    var body: some View
    {
        List
        {
            Section("Defaults")
            {
                Picker(selection: $defaultCommentSorting)
                {
                    ForEach(CommentSortTypes.allCases)
                    { sortingOption in
                        Text(String(describing: sortingOption))
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.up.arrow.down.square.fill")
                            .foregroundColor(.gray)
                        Text("Comment sorting")
                    }
                }
                
                Picker(selection: $defaultFeed)
                {
                    ForEach(FeedType.allCases)
                    { feedType in
                        Text(String(describing: feedType))
                    }
                } label: {
                    HStack(alignment: .center) {
                        Image(systemName: "arrow.up.arrow.down.square.fill")
                            .foregroundColor(.gray)
                        Text("Feed")
                    }
                }
                
                Button(role: .destructive) {
                    isShowingResetDefaultsConfirmation.toggle()
                } label: {
                    Label("Reset Defaults", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .confirmationDialog(
                    "Reset default options?",
                    isPresented: $isShowingResetDefaultsConfirmation,
                    titleVisibility: .visible) {
                        Button(role: .destructive) {
                            defaultFeed = .subscribed
                            defaultCommentSorting = .top
                        } label: {
                            Text("Reset defaults")
                        }

                        Button(role: .cancel) {
                            isShowingResetDefaultsConfirmation.toggle()
                        } label: {
                            Text("Cancel")
                        }

                } message: {
                    Text("Would you like to delete all your favorited communities for all accounts?\nYou cannot undo this action.")
                }
                
            }
            
            Section
            {
                Button(role: .destructive) {
                    isShowingFavoritesDeletionConfirmation.toggle()
                } label: {
                    Label("Delete favorites", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .disabled(favoritesTracker.favoriteCommunities.isEmpty)
                .confirmationDialog(
                    "Delete favorites for all accounts?",
                    isPresented: $isShowingFavoritesDeletionConfirmation,
                    titleVisibility: .visible) {
                        Button(role: .destructive) {
                            do
                            {
                                try FileManager.default.removeItem(at: AppConstants.favoriteCommunitiesFilePath)
                                
                                do
                                {
                                    try createEmptyFile(at: AppConstants.favoriteCommunitiesFilePath)
                                    
                                    favoritesTracker.favoriteCommunities = .init()
                                }
                                catch let emptyFileCreationError
                                {
                                    
                                    appState.alertTitle = "Couldn't recreate favorites file"
                                    appState.alertMessage = "Try restarting Mlem."
                                    appState.isShowingAlert.toggle()
                                    
                                    print("Failed while creting empty file: \(emptyFileCreationError)")
                                }
                            }
                            catch let fileDeletionError
                            {
                                appState.alertTitle = "Couldn't delete favorites"
                                appState.alertMessage = "Try restarting Mlem."
                                appState.isShowingAlert.toggle()
                                
                                print("Failed while deleting favorites: \(fileDeletionError)")
                            }
                        } label: {
                            Text("Delete all favorites")
                        }

                        Button(role: .cancel) {
                            isShowingFavoritesDeletionConfirmation.toggle()
                        } label: {
                            Text("Cancel")
                        }

                } message: {
                    Text("Would you like to delete all your favorited communities for all accounts?\nYou cannot undo this action.")
                }

            }
        }
    }
}
