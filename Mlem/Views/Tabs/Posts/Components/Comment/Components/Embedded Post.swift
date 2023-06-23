//
//  Embedded Post.swift
//  Mlem
//
//  Created by Eric Andrews on 2023-06-23.
//

import SwiftUI

struct EmbeddedPost: View {
    let post: APIPost
    
    var body: some View {
        Text(post.name)
            .padding(4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.secondary)
            .background(RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(UIColor.secondarySystemBackground)))
            .font(.subheadline)
            .bold()
    }
}
