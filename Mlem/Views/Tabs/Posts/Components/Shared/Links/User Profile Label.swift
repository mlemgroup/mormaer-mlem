//
//  User Profile Label.swift
//  Mlem
//
//  Created by Jake Shirley on 6/21/23.
//

import SwiftUI
import CachedAsyncImage

struct UserProfileLabel: View {
    @AppStorage("shouldShowUserAvatars") var shouldShowUserAvatars: Bool = true

    @State var account: SavedAccount
    @State var user: APIPerson
    @State var showServerInstance: Bool

    // Extra context about where the link is being displayed
    // to pick the correct flair
    @State var postContext: APIPostView?
    @State var commentContext: APIComment?
    @State var communityContext: GetCommunityResponse?

    static let developerNames = [
        "vlemmy.net/u/darknavi",
        "lemmy.ml/u/BrooklynMan",
        "beehaw.org/u/jojo",
        "sh.itjust.works/u/ericbandrews"
    ]

    static let flairDeveloper = UserProfileLinkFlair(color: Color.purple, systemIcon: "hammer.fill")
    static let flairMod = UserProfileLinkFlair(color: Color.green, systemIcon: "shield.fill")
    static let flairBot = UserProfileLinkFlair(color: Color.indigo, systemIcon: "server.rack")
    static let flairOP = UserProfileLinkFlair(color: Color.orange, systemIcon: "person.fill")
    static let flairAdmin = UserProfileLinkFlair(color: Color.red, systemIcon: "crown.fill")
    static let flairRegular = UserProfileLinkFlair(color: Color.gray)

    var body: some View {
        HStack(alignment: .center, spacing: 5) {
            if shouldShowUserAvatars {
                if let avatarLink = user.avatar {
                    AvatarView(avatarLink: avatarLink)
                }
            }

            let flair = calculateLinkFlair()
            if let flairSystemIcon = flair.systemIcon {
                Image(systemName: flairSystemIcon).foregroundColor(flair.color)
            }

            HStack(spacing: 0) {
                // User display name if one exists
                Text(user.displayName ?? user.name)
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .bold()
                    .foregroundColor(flair.color)
                
                if showServerInstance {
                    if let host = user.actorId.host() {
                        Text("@\(host)")
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .foregroundColor(flair.color)
                            .opacity(0.6)
                    }
                }
            }
        }
    }

    struct UserProfileLinkFlair {
        var color: Color
        var systemIcon: String?
    }

    private func calculateLinkFlair() -> UserProfileLinkFlair {
        if let userServer = user.actorId.host() {
            if UserProfileLabel.developerNames.contains(where: { $0 == "\(userServer)\(user.actorId.path())" }) {
                return UserProfileLabel.flairDeveloper
            }
        }
        if user.admin {
            return UserProfileLabel.flairAdmin
        }
        if user.botAccount {
            return UserProfileLabel.flairBot
        }
        if let comment = commentContext {
            if comment.distinguished {
                return UserProfileLabel.flairMod
            }
        }
        if let community = communityContext {
            if community.moderators.contains(where: { $0.moderator == user }) {
                return UserProfileLabel.flairMod
            }
        }
        if let post = postContext {
            if user == post.creator {
                return UserProfileLabel.flairOP
            }
        }
        return UserProfileLabel.flairRegular
    }
}

// TODO: darknavi - Move these to a common area for reuse
struct UserProfileLinkPreview: PreviewProvider {
    static let previewAccount = SavedAccount(
        id: 0,
        instanceLink: URL(string: "lemmy.com")!,
        accessToken: "abcdefg",
        username: "Test Account"
    )

    // Only Admin and Bot work right now
    // Because the rest require post/comment context
    enum PreviewUserType: String, CaseIterable {
        case normal = "normal"
        case mod = "mod"
        case op = "op"
        case bot = "bot"
        case admin = "admin"
        case dev = "developer"
    }

    static func generatePreviewUser(name: String, displayName: String, userType: PreviewUserType) -> APIPerson {
        let actorId: URL
        if userType == .dev {
            actorId = URL(string: "http://\(UserProfileLabel.developerNames[0])")!
        } else {
            actorId = URL(string: "google.com")!
        }
        
        return APIPerson(
            id: name.hashValue,
            name: name,
            displayName: displayName,
            avatar: nil,
            banned: false,
            published: Date.now.advanced(by: -120000),
            updated: nil,
            actorId: actorId,
            bio: nil,
            local: false,
            banner: nil,
            deleted: false,
            sharedInboxUrl: nil,
            matrixUserId: nil,
            admin: userType == .admin,
            botAccount: userType == .bot,
            banExpires: nil,
            instanceId: 123
        )
    }

    static func generatePreviewComment(creator: APIPerson, isMod: Bool) -> APIComment {
        APIComment(
            id: 0,
            creatorId: creator.id,
            postId: 0,
            content: "",
            removed: false,
            deleted: false,
            published: Date.now,
            updated: nil,
            apId: "foo.bar",
            local: false,
            path: "foo",
            distinguished: isMod,
            languageId: 0
        )
    }

    static func generateFakeCommunity(id: Int, namePrefix: String) -> APICommunity {
        APICommunity(
            id: id,
            name: "\(namePrefix) Fake Community \(id)",
            title: "\(namePrefix) Fake Community \(id) Title",
            description: "This is a fake community (#\(id))",
            published: Date.now,
            updated: nil,
            removed: false,
            deleted: false,
            nsfw: false,
            actorId: URL(string: "https://lemmy.google.com/c/\(id)")!,
            local: false,
            icon: nil,
            banner: nil,
            hidden: false,
            postingRestrictedToMods: false,
            instanceId: 0
        )
    }

    static func generatePreviewPost(creator: APIPerson) -> APIPostView {
        let community = generateFakeCommunity(id: 123, namePrefix: "Test")
        let post = APIPost(
            id: 123,
            name: "Test Post Title",
            url: nil,
            body: "This is a test post body",
            creatorId: creator.id,
            communityId: 123,
            deleted: false,
            embedDescription: "Embeedded Description",
            embedTitle: "Embedded Title",
            embedVideoUrl: nil,
            featuredCommunity: false,
            featuredLocal: false,
            languageId: 0,
            apId: "my.app.id",
            local: false,
            locked: false,
            nsfw: false,
            published: Date.now,
            removed: false,
            thumbnailUrl: nil,
            updated: nil
        )

        let postVotes = APIPostAggregates(
            id: 123,
            postId: post.id,
            comments: 0,
            score: 10,
            upvotes: 15,
            downvotes: 5,
            published: Date.now,
            newestCommentTime: Date.now,
            newestCommentTimeNecro: Date.now,
            featuredCommunity: false,
            featuredLocal: false
        )

        return APIPostView(
            post: post,
            creator: creator,
            community: community,
            creatorBannedFromCommunity: false,
            counts: postVotes,
            subscribed: .notSubscribed,
            saved: false,
            read: false,
            creatorBlocked: false,
            unreadComments: 0
        )
    }

    static func generateUserProfileLink(
        name: String,
        userType: PreviewUserType,
        showCommunity: Bool
    ) -> UserProfileLink {
        let previewUser = generatePreviewUser(name: name, displayName: name, userType: userType);
        
        var postContext: APIPostView?
        var commentContext: APIComment?
        
        if userType == .mod {
            commentContext = generatePreviewComment(creator: previewUser, isMod: true)
        }

        if userType == .op {
            commentContext = generatePreviewComment(creator: previewUser, isMod: false)
            postContext = generatePreviewPost(creator: previewUser)
        }
        
        return UserProfileLink(
            account: UserProfileLinkPreview.previewAccount,
            user: previewUser,
            showServerInstance: showCommunity,
            postContext: postContext,
            commentContext: commentContext
        )
    }

    static var previews: some View {
        VStack {
            Spacer()
            ForEach(PreviewUserType.allCases, id: \.rawValue) { userType in
                generateUserProfileLink(name: "\(userType)User", userType: userType, showCommunity: false)
            }
            Spacer()
            ForEach(PreviewUserType.allCases, id: \.rawValue) {
                userType in
                generateUserProfileLink(name: "\(userType)User", userType: userType, showCommunity: true)
            }
            Spacer()
        }
    }
}
