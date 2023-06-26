//
//  Comment Tracker.swift
//  Mlem
//
//  Created by David Bureš on 04.05.2023.
//

import Foundation

class CommentTracker: ObservableObject
{
    @Published var comments: [HierarchicalComment] = .init()
    @Published var isLoading: Bool = true
    
    /// A method to add new comments into the tracker, duplicate comments will be rejected
    func add(_ newComments: [HierarchicalComment]) {
        let accepted = newComments.filter {
            let newComment = $0
            return !comments.contains(where: {
                $0.id == newComment.id
                
            })
        }
        comments.append(contentsOf: accepted)
    }
}
