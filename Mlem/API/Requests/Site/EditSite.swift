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
        let enable_downvotes: Bool?
        let enable_nsfw: Bool?
        let community_creation_admin_only: Bool?
        let require_email_verification: Bool?
        let application_question: String?
        let private_instance: Bool?
        let default_theme: String?
        let default_post_listing_type: String?
        let legal_information: String?
        let application_email_admins: String?
        let hide_modlog_mod_names: Bool?
        let discussion_languages: [Int]?
        let slur_filter_regex: String?
        let actor_name_max_length: Int?

        let rate_limit_message: Int?
        let rate_limit_message_per_second: Int?
        let rate_limit_post: Int?
        let rate_limit_post_per_second: Int?
        let rate_limit_register: Int?
        let rate_limit_register_per_second: Int?
        let rate_limit_image: Int?
        let rate_limit_image_per_second: Int?
        let rate_limit_comment: Int?
        let rate_limit_comment_per_second: Int?
        let rate_limit_search: Int?
        let rate_limit_search_per_second: Int?

        let federation_enabled: Bool?
        let federation_debug: Bool?
        let federation_worker_count: Int?
        let captcha_enabled: Bool?
        let captcha_difficulty: String?

        let allowed_instances: [String]?
        let blocked_instances: [String]?
        let taglines: [String]?
        let registration_mode: APIRegistrationMode?
        let reports_email_admins: Bool?

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

        federationEnabled: Bool? = nil,
        federationDebug: Bool? = nil,
        federationWorkerCount: Int? = nil,
        captchaEnabled: Bool? = nil,
        captchaDifficulty: String? = nil,

        allowedInstances: [String]? = nil,
        blockedInstances: [String]? = nil,
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
            enable_downvotes: enableDownvotes,
            enable_nsfw: enableNsfw,
            community_creation_admin_only: communityCreationAdminOnly,
            require_email_verification: requireEmailVerification,
            application_question: applicationQuestion,
            private_instance: privateInstance,
            default_theme: defaultTheme,
            default_post_listing_type: defaultPostListingType,
            legal_information: legalInformation,
            application_email_admins: applicationEmailAdmins,
            hide_modlog_mod_names: hideModlogModNames,
            discussion_languages: discussionLanguages,
            slur_filter_regex: slurFilterRegex,
            actor_name_max_length: actorMaxNameLength,

            rate_limit_message: rateLimitMessage,
            rate_limit_message_per_second: rateLimitMessagePerSecond,
            rate_limit_post: rateLimitPost,
            rate_limit_post_per_second: rateLimitPostPerSecond,
            rate_limit_register: rateLimitRegister,
            rate_limit_register_per_second: rateLimitRegisterPerSecond,
            rate_limit_image: rateLimitImage,
            rate_limit_image_per_second: rateLimitImagePerSecond,
            rate_limit_comment: rateLimitComment,
            rate_limit_comment_per_second: rateLimitCommentPerSecond,
            rate_limit_search: rateLimitSearch,
            rate_limit_search_per_second: rateLimitSearchPerSecond,

            federation_enabled: federationEnabled,
            federation_debug: federationDebug,
            federation_worker_count: federationWorkerCount,
            captcha_enabled: captchaEnabled,
            captcha_difficulty: captchaDifficulty,

            allowed_instances: allowedInstances,
            blocked_instances: blockedInstances,
            taglines: taglines,
            registration_mode: registrationMode,
            reports_email_admins: reportsEmailAdmins,
            auth: account.accessToken
        )
    }
}
