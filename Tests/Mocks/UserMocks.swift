//
//  UserMocks.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 03/12/2018.
//

import Foundation

public struct UserMocks {
  
  static let fullUser = """
  {
    "id": 2,
    "name": "Shai Mishali",
    "username": "freak4pc",
    "state": "active",
    "avatar_url": "http://c20945ccd3bd/uploads/-/system/user/avatar/2/605076.jpeg",
    "web_url": "http://c20945ccd3bd/freak4pc",
    "created_at": "2018-10-30T10:41:22.710Z",
    "bio": null,
    "location": null,
    "public_email": "",
    "skype": "",
    "linkedin": "",
    "twitter": "",
    "website_url": "",
    "organization": null,
    "last_sign_in_at": "2018-10-30T10:44:03.991Z",
    "confirmed_at": "2018-10-30T10:41:22.566Z",
    "last_activity_on": null,
    "email": "freak4pc@test.com",
    "theme_id": 1,
    "color_scheme_id": 1,
    "projects_limit": 100000,
    "current_sign_in_at": "2018-12-03T10:46:20.282Z",
    "identities": [],
    "can_create_group": true,
    "can_create_project": true,
    "two_factor_enabled": false,
    "external": false,
    "private_profile": null,
    "shared_runners_minutes_limit": null
  }
  """
  
  static var fullUserData: Data {
    return UserMocks.fullUser.data()
  }
  
  static let fullUserPrivateToken = "6j3JtRByXdyL8sVdLsPz"
  
  static let user = """
  {
    "id": 2,
    "name": "Shai Mishali",
    "username": "freak4pc",
    "state": "active",
    "avatar_url": "http://c20945ccd3bd/uploads/-/system/user/avatar/2/605076.jpeg",
    "web_url": "http://c20945ccd3bd/freak4pc",
    "created_at": "2018-10-30T10:41:22.710Z",
    "bio": null,
    "location": null,
    "public_email": "",
    "skype": "",
    "linkedin": "",
    "twitter": "",
    "website_url": "",
    "organization": null
  }
  """
  
  static var userData: Data {
    return UserMocks.user.data()
  }
  
  static let users = """
  [
    {
      "id": 1,
      "name": "Krunoslav Zaher",
      "username": "kzaher",
      "state": "active",
      "avatar_url": "http://c20945ccd3bd/uploads/-/system/user/avatar/4/1641148.jpg",
      "web_url": "http://c20945ccd3bd/kzaher"
    },
    {
      "id": 2,
      "name": "Junior B.",
      "username": "bontoJR",
      "state": "active",
      "avatar_url": "https://www.gravatar.com/avatar/672cb7376dd48e973742b84528adec8c?s=80\\u0026d=identicon",
      "web_url": "http://c20945ccd3bd/bontoJR"
    },
    {
        "id": 3,
        "name": "Shai Mishali",
        "username": "freak4pc",
        "state": "active",
        "avatar_url": "http://c20945ccd3bd/uploads/-/system/user/avatar/2/605076.jpeg",
        "web_url": "http://c20945ccd3bd/freak4pc"
    }
  ]
"""
  static var usersData: Data {
    return UserMocks.users.data()
  }
}
