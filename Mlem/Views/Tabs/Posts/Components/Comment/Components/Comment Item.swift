//
//  Comment View.swift
//  Mlem
//
//  Created by David Bureš on 25.03.2022.
//

import SwiftUI

struct CommentItem: View
{
    @EnvironmentObject var commentReplyTracker: CommentReplyTracker
    @EnvironmentObject var commentTracker: CommentTracker
    
    @EnvironmentObject var appState: AppState
    
    @State var account: SavedAccount
    
    let comment: Comment
    
    @State var isCollapsed = false
    
    @State private var isShowingTextSelectionSheet: Bool = false
    
    @State var dragPosition: CGSize = .zero
    @State var dragBackground: Color = .systemBackground
    
    func upvoteComment() async -> Bool {
        do {
            switch comment.myVote {
                case .upvoted:
                    try await rateComment(comment: comment, operation: .resetVote, account: account, commentTracker: commentTracker, appState: appState)
                case .downvoted:
                    try await rateComment(comment: comment, operation: .upvote, account: account, commentTracker: commentTracker, appState: appState)
                case .none:
                    try await rateComment(comment: comment, operation: .upvote, account: account, commentTracker: commentTracker, appState: appState)
            }
        } catch {
            return false
        }
        
        return true
    }
    
    func downvoteComment() async -> Bool {
        do {
            switch comment.myVote {
                case .upvoted:
                    try await rateComment(comment: comment, operation: .downvote, account: account, commentTracker: commentTracker, appState: appState)
                case .downvoted:
                    try await rateComment(comment: comment, operation: .resetVote, account: account, commentTracker: commentTracker, appState: appState)
                case .none:
                    try await rateComment(comment: comment, operation: .downvote, account: account, commentTracker: commentTracker, appState: appState)
            }
        } catch {
            return false
        }
        
        return true
    }

    var body: some View
    {
        VStack(alignment: .leading, spacing: 10)
            {
                ZStack {
                    dragBackground
                    ZStack {
                        Color(.systemBackground)
                            .offset(x: dragPosition.width)
                        VStack {
                            if comment.deleted!
                            {
                                Text("Comment was deleted")
                                    .italic()
                                    .foregroundColor(.secondary)
                                    .offset(x: dragPosition.width)
                            }
                            else
                            {
                                if comment.removed
                                {
                                    Text("Comment was removed")
                                        .italic()
                                        .foregroundColor(.secondary)
                                        .offset(x: dragPosition.width)
                                }
                                else
                                {
                                    if !isCollapsed
                                    {
                                        MarkdownView(text: comment.content)
                                            .offset(x: dragPosition.width)
                                            .frame(maxWidth: .infinity, alignment: .topLeading)
                                            .transition(.move(edge: .top).combined(with: .opacity))
                                    }
                                }
                            }
                            
                            HStack(spacing: 12)
                            {
                                #warning("TODO: Add post rating")
                                HStack
                                {
                                    HStack(alignment: .center, spacing: 2) {
                                        Image(systemName: "arrow.up")
                                        
                                        Text(String(comment.score))
                                    }
                                    .if(comment.myVote == .none || comment.myVote == .downvoted)
                                    { viewProxy in
                                        viewProxy
                                            .foregroundColor(.accentColor)
                                    }
                                    .if(comment.myVote == .upvoted)
                                    { viewProxy in
                                        viewProxy
                                            .foregroundColor(.green)
                                    }
                                    .onTapGesture {
                                        Task(priority: .userInitiated) {
                                            await upvoteComment()
                                        }
                                    }
                                    
                                    Image(systemName: "arrow.down")
                                        .if(comment.myVote == .downvoted)
                                    { viewProxy in
                                            viewProxy
                                                .foregroundColor(.red)
                                        }
                                        .if(comment.myVote == .upvoted || comment.myVote == .none)
                                    { viewProxy in
                                            viewProxy
                                                .foregroundColor(.accentColor)
                                        }
                                        .onTapGesture {
                                            Task(priority: .userInitiated) {
                                                await downvoteComment()
                                            }
                                        }
                                }
                                
                                HStack(spacing: 4)
                                {
                                    Button(action: {
                                        print("Would reply to comment ID \(comment.id)")
                                        
                                        commentReplyTracker.commentToReplyTo = comment
                                    }, label: {
                                        Image(systemName: "arrowshape.turn.up.backward")
                                    })
                                    
                                    Text("Reply")
                                        .foregroundColor(.accentColor)
                                }
                                
                                Spacer()
                                
                                HStack
                                {
                #warning("TODO: Make the text selection work")
                                    /*
                                    Menu {
                                    Button {
                                    isShowingTextSelectionSheet.toggle()
                                    } label: {
                                    Label("Select text", systemImage: "selection.pin.in.out")
                                    }
                                    
                                    } label: {
                                    Label("More Actions", systemImage: "ellipsis")
                                    .labelStyle(.iconOnly)
                                    }
                                    */
                                    
                                    Text(getTimeIntervalFromNow(date: comment.published))
                                    UserProfileLink(account: account, user: comment.author)
                                }
                                .foregroundColor(.secondary)
                            }
                            .disabled(isCollapsed)
                            .onTapGesture {
                                if isCollapsed
                                {
                                    withAnimation(Animation.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 0.4))
                                    {
                                        isCollapsed.toggle()
                                    }
                                }
                            }
                            .offset(x: dragPosition.width)
                        
                            Divider()
                                .offset(x: dragPosition.width)
                        }
                    }
                }
                
            
                if !isCollapsed
                {
                    VStack(alignment: .leading, spacing: 10)
                    {
                        ForEach(comment.children)
                        { comment in
                            CommentItem(account: account, comment: comment)
                        }
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .clipped()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged {
                        let w = $0.translation.width
                        if w > AppConstants.downvoteDragMin {
                            dragBackground = .red
                        } else if w > AppConstants.upvoteDragMin {
                            dragBackground = .green
                        } else if $0.translation.width < AppConstants.collapseDragMax {
                            dragBackground = .blue
                        } else {
                            dragBackground = .systemBackground
                        }
                        dragPosition = $0.translation
                    }
                    .onEnded {
                        if $0.translation.width > AppConstants.downvoteDragMin {
                            Task(priority: .userInitiated) {
                                await downvoteComment()
                            }
                        } else if $0.translation.width > AppConstants.upvoteDragMin {
                            Task(priority: .userInitiated) {
                                await upvoteComment()
                            }
                        } else if $0.translation.width < AppConstants.collapseDragMax {
                            withAnimation(Animation.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 0.5))
                            {
                                isCollapsed.toggle()
                            }
                        }
                        dragPosition = .zero
                        dragBackground = .systemBackground
                    }
                )
        .clipped()
        .contentShape(Rectangle())
        .onTapGesture
        {
            withAnimation(Animation.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 0.4))
            {
                isCollapsed.toggle()
            }
        }
        .dynamicTypeSize(.small)
        .background(Color.systemBackground)
        .padding(comment.parentID == nil ? .horizontal : .leading)
        .sheet(isPresented: $isShowingTextSelectionSheet) {
            NavigationView {
                VStack(alignment: .center, spacing: 0) {
                    Text(comment.content)
                        .textSelection(.enabled)
                    Spacer()
                }
                .navigationTitle("Select text")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingTextSelectionSheet.toggle()
                        } label: {
                            Text("Close")
                        }
                        
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }
}
