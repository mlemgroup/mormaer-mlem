//
//  PostComposerView.swift
//  Mlem
//
//  Created by Weston Hanners on 6/29/23.
//

import SwiftUI

struct PostComposerView: View {
    
    init(community: APICommunity) {
        self.community = community
    }
    
    var community: APICommunity
    
    let iconWidth: CGFloat = 24
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var postTracker: PostTracker
    @EnvironmentObject var appState: AppState

    @State var postTitle: String = ""
    @State var postURL: String = ""
    @State var postBody: String = ""
    @State var isNSFW: Bool = false
    
    @State var isSubmitting: Bool = false
    
    func submitPost() async {
        do {
            guard let account = appState.currentActiveAccount else {
                print("Cannot Submit, No Active Account")
                return
            }
            
            isSubmitting = true
            
            try await postPost(to: community,
                               postTitle: postTitle,
                               postBody: postBody,
                               postURL: postURL,
                               postIsNSFW: isNSFW,
                               postTracker: postTracker,
                               account: account)
            
            print("Post Successful")
            
            dismiss()
            
        } catch {
            print("Something went wrong)")
        }
        print("Submitting")
    }
    
    func uploadImage() {
        print("Uploading")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 15) {
                    // Title Row
                    HStack {
                        Image(systemName: "megaphone.fill")
                            .font(.title3)
                            .dynamicTypeSize(.medium)
                            .frame(width: iconWidth)
                            .accessibilityHidden(true)
                        Text("Title").font(.title3)
                        TextField("Post Title",
                                  text: $postTitle)
                    }
                    
                    // URL Row
                    HStack(spacing: 10) {
                        Image(systemName: "globe")
                            .font(.title3)
                            .dynamicTypeSize(.medium)
                            .frame(width: iconWidth)
                            .accessibilityHidden(true)
                        Text("URL")
                            .font(.title3)
                        TextField("Post URL",
                                  text: $postURL)
                        .autocorrectionDisabled()
                        
                        // Upload button, temporarily hidden
//                        Button(action: uploadImage) {
//                            Image(systemName: "photo")
//                                .font(.title3)
//                                .dynamicTypeSize(.medium)
//                        }
//                        .accessibilityLabel("Upload Image")
                    }
                    
                    // Post Text
                    TextField("What do you want to say?",
                              text: $postBody,
                              axis: .vertical).lineLimit(5...10)
                    Spacer()
                    
                    // NSFW Toggle
                    HStack(spacing: 10) {
                        Image(systemName: "eye.fill")
                            .font(.title3)
                            .dynamicTypeSize(.medium)
                            .frame(width: iconWidth)
                            .accessibilityHidden(true)
                        Toggle("NSFW", isOn: $isNSFW)
                            .font(.title3)
                    }
                    
                    VStack {
                        Text("Posting in \(community.name)").font(.subheadline)
                    }
                    
                    // Submit Button
                    Button {
                        Task(priority: .userInitiated) {
                            await submitPost()
                        }
                    } label: {
                        Text("Submit").font(.title2).padding()
                    }.disabled(isSubmitting)
                }
                .padding()
                
                // Loading Indicator
                if isSubmitting {
                    ZStack {
                        Color.gray.opacity(0.3)
                        ProgressView()
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Submitting Post")
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                }
            }

            .navigationTitle("New Post")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                    .tint(.red)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PostComposerView_Previews: PreviewProvider {
    static let community = generateFakeCommunity(id: 1,
                                                 namePrefix: "mlem")
        
    static var previews: some View {
        NavigationStack {
            PostComposerView(community: community)
        }
    }
}
