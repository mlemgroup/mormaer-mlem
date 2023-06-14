//
//  EditSite.swift
//  Mlem
//
//  Created by Jonathan de Jong on 12.06.2023.
//

import Foundation

struct EditSiteRequest: APIPutRequest {

    typealias Response = SiteResponse

    let instanceURL: URL
    let path = "site"
    let body: Body

    // lemmy_api_common::site::CreateSite
    struct Body: Encodable {
        let name: String?
        let sidebar: String?
        let description: String?
        let icon: URL?
        let banner: URL?
        let enableDownvotes: Bool?
        let enableNsfw: Bool?
        let communityCreationAdminOnly: Bool?
        let requireEmailVerification: Bool?
        let applicationQuestion: String?
        let privateInstance: Bool?
        let defaultTheme: String?
        let defaultPostListingType: String?
        let legalInformation: String?
        let applicationEmailAdmins: String?
        let hideModlogModNames: Bool?
        let discussionLanguages: [Int]?
        let slurFilterRegex: String?
        let actorMaxNameLength: Int?

        let rateLimitMessage: Int?
        let rateLimitMessagePerSecond: Int?
        let rateLimitPost: Int?
        let rateLimitPostPerSecond: Int?
        let rateLimitRegister: Int?
        let rateLimitRegisterPerSecond: Int?
        let rateLimitImage: Int?
        let rateLimitImagePerSecond: Int?
        let rateLimitComment: Int?
        let rateLimitCommentPerSecond: Int?
        let rateLimitSearch: Int?
        let rateLimitSearchPerSecond: Int?

        let federationEnabled: Int?
        let federationDebug: Int?
        let federationWorkerCount: Int?
        let captchaEnabled: Int?
        let captchaDifficulty: String?

        let allowedInstances: Int?
        let blockedInstances: Int?
        let taglines: [String]?
        let registrationMode: APIRegistrationMode?
        let reportsEmailAdmins: Bool?

        let auth: String
    }

    init(
        account: SavedAccount,
        name: String? = nil,
        sidebar: String? = nil,
        description: String? = nil,
        icon: URL? = nil,
        banner: URL? = nil,
        enableDownvotes: Bool? = nil,
        enableNsfw: Bool? = nil,
        communityCreationAdminOnly: Bool? = nil,
        requireEmailVerification: Bool? = nil,
        applicationQuestion: String? = nil,
        privateInstance: Bool? = nil,
        defaultTheme: String? = nil,
        defaultPostListingType: String? = nil,
        legalInformation: String? = nil,
        applicationEmailAdmins: String? = nil,
        hideModlogModNames: Bool? = nil,
        discussionLanguages: [Int]? = nil,
        slurFilterRegex: String? = nil,
        actorMaxNameLength: Int? = nil,

        rateLimitMessage: Int? = nil,
        rateLimitMessagePerSecond: Int? = nil,
        rateLimitPost: Int? = nil,
        rateLimitPostPerSecond: Int? = nil,
        rateLimitRegister: Int? = nil,
        rateLimitRegisterPerSecond: Int? = nil,
        rateLimitImage: Int? = nil,
        rateLimitImagePerSecond: Int? = nil,
        rateLimitComment: Int? = nil,
        rateLimitCommentPerSecond: Int? = nil,
        rateLimitSearch: Int? = nil,
        rateLimitSearchPerSecond: Int? = nil,

        federationEnabled: Int? = nil,
        federationDebug: Int? = nil,
        federationWorkerCount: Int? = nil,
        captchaEnabled: Int? = nil,
        captchaDifficulty: String? = nil,

        allowedInstances: Int? = nil,
        blockedInstances: Int? = nil,
        taglines: [String]? = nil,
        registrationMode: APIRegistrationMode? = nil,
        reportsEmailAdmins: Bool? = nil
    ) {
        self.instanceURL = account.instanceLink

        self.body = .init(
            name: name,
            sidebar: sidebar,
            description: description,
            icon: icon,
            banner: banner,
            enableDownvotes: enableDownvotes,
            enableNsfw: enableNsfw,
            communityCreationAdminOnly: communityCreationAdminOnly,
            requireEmailVerification: requireEmailVerification,
            applicationQuestion: applicationQuestion,
            privateInstance: privateInstance,
            defaultTheme: defaultTheme,
            defaultPostListingType: defaultPostListingType,
            legalInformation: legalInformation,
            applicationEmailAdmins: applicationEmailAdmins,
            hideModlogModNames: hideModlogModNames,
            discussionLanguages: discussionLanguages,
            slurFilterRegex: slurFilterRegex,
            actorMaxNameLength: actorMaxNameLength,

            rateLimitMessage: rateLimitMessage,
            rateLimitMessagePerSecond: rateLimitMessagePerSecond,
            rateLimitPost: rateLimitPost,
            rateLimitPostPerSecond: rateLimitPostPerSecond,
            rateLimitRegister: rateLimitRegister,
            rateLimitRegisterPerSecond: rateLimitRegisterPerSecond,
            rateLimitImage: rateLimitImage,
            rateLimitImagePerSecond: rateLimitImagePerSecond,
            rateLimitComment: rateLimitComment,
            rateLimitCommentPerSecond: rateLimitCommentPerSecond,
            rateLimitSearch: rateLimitSearch,
            rateLimitSearchPerSecond: rateLimitSearchPerSecond,

            federationEnabled: federationEnabled,
            federationDebug: federationDebug,
            federationWorkerCount: federationWorkerCount,
            captchaEnabled: captchaEnabled,
            captchaDifficulty: captchaDifficulty,

            allowedInstances: allowedInstances,
            blockedInstances: blockedInstances,
            taglines: taglines,
            registrationMode: registrationMode,
            reportsEmailAdmins: reportsEmailAdmins,
            auth: account.accessToken
        )
    }
}
