//
//  User.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 26/08/2018.
//

import Foundation

public struct User: Codable {
  public let id: Int
  public let username: String
  public let email: String?
  public let name: String?
  public let state: String?
  public let avatarUrl: String?
  public let webUrl: String?
  public let createdAt: Date?
  public let isAdmin: Bool?
  public let bio: String?
  public let location: String?
  public let skype: String?
  public let linkedin: String?
  public let twitter: String?
  public let websiteUrl: String?
  public let organization: String?
  public let lastSignInAt: Date?
  public let confirmedAt: Date?
  public let themeId: Int?
  public let lastActivityOn: Date?
  public let colorSchemeId: Int?
  public let projectsLimit: Int?
  public let currentSignInAt: Date?
  public let identities: [Identities]?
  public let canCreateGroup: Bool?
  public let canCreateProject: Bool?
  public let twoFactorEnabled: Bool?
  public let external: Bool?
  public let privateProfile: Bool?
  public let sharedRunnersMinutesLimit: Int?

  enum CodingKeys: String, CodingKey {

    case id = "id"
    case username = "username"
    case email = "email"
    case name = "name"
    case state = "state"
    case avatarUrl = "avatar_url"
    case webUrl = "web_url"
    case createdAt = "created_at"
    case isAdmin = "is_admin"
    case bio = "bio"
    case location = "location"
    case skype = "skype"
    case linkedin = "linkedin"
    case twitter = "twitter"
    case websiteUrl = "website_url"
    case organization = "organization"
    case lastSignInAt = "last_sign_in_at"
    case confirmedAt = "confirmed_at"
    case themeId = "theme_id"
    case lastActivityOn = "last_activity_on"
    case colorSchemeId = "color_scheme_id"
    case projectsLimit = "projects_limit"
    case currentSignInAt = "current_sign_in_at"
    case identities = "identities"
    case canCreateGroup = "can_create_group"
    case canCreateProject = "can_create_project"
    case twoFactorEnabled = "two_factor_enabled"
    case external = "external"
    case privateProfile = "private_profile"
    case sharedRunnersMinutesLimit = "shared_runners_minutes_limit"
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decode(Int.self, forKey: .id)
    username = try values.decode(String.self, forKey: .username)
    email = try values.decodeIfPresent(String.self, forKey: .email)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    state = try values.decodeIfPresent(String.self, forKey: .state)
    avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl)
    webUrl = try values.decodeIfPresent(String.self, forKey: .webUrl)
    createdAt = try User.decodeDateIfPresent(values: values, forKey: .createdAt)
    isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
    bio = try values.decodeIfPresent(String.self, forKey: .bio)
    location = try values.decodeIfPresent(String.self, forKey: .location)
    skype = try values.decodeIfPresent(String.self, forKey: .skype)
    linkedin = try values.decodeIfPresent(String.self, forKey: .linkedin)
    twitter = try values.decodeIfPresent(String.self, forKey: .twitter)
    websiteUrl = try values.decodeIfPresent(String.self, forKey: .websiteUrl)
    organization = try values.decodeIfPresent(String.self, forKey: .organization)
    lastSignInAt =  try User.decodeDateIfPresent(values: values, forKey: .lastSignInAt)
    confirmedAt =  try User.decodeDateIfPresent(values: values, forKey: .confirmedAt)
    themeId = try values.decodeIfPresent(Int.self, forKey: .themeId)
    lastActivityOn = try User.decodeDateDayIfPresent(values: values, forKey: .lastActivityOn)
    colorSchemeId = try values.decodeIfPresent(Int.self, forKey: .colorSchemeId)
    projectsLimit = try values.decodeIfPresent(Int.self, forKey: .projectsLimit)
    currentSignInAt =  try User.decodeDateIfPresent(values: values, forKey: .currentSignInAt)
    identities = try values.decodeIfPresent([Identities].self, forKey: .identities)
    canCreateGroup = try values.decodeIfPresent(Bool.self, forKey: .canCreateGroup)
    canCreateProject = try values.decodeIfPresent(Bool.self, forKey: .canCreateProject)
    twoFactorEnabled = try values.decodeIfPresent(Bool.self, forKey: .twoFactorEnabled)
    external = try values.decodeIfPresent(Bool.self, forKey: .external)
    privateProfile = try values.decodeIfPresent(Bool.self, forKey: .privateProfile)
    sharedRunnersMinutesLimit = try values.decodeIfPresent(Int.self, forKey: .sharedRunnersMinutesLimit)

  }

  private static func decodeDateIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }

  private static func decodeDateDayIfPresent(values: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let dateString = try values.decodeIfPresent(String.self, forKey: key), let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil
    }
  }

}
