//
//  ProjectMocks.swift
//  RxGitLabKit
//
//  Created by Dagy Tran on 01/11/2018.
//

import Foundation

public struct ProjectMocks {
  public static let projectData = """
{
    "id": 4,
    "description": null,
    "default_branch": "master",
    "visibility": "private",
    "ssh_url_to_repo": "git@example.com:diaspora/diaspora-client.git",
    "http_url_to_repo": "http://example.com/diaspora/diaspora-client.git",
    "web_url": "http://example.com/diaspora/diaspora-client",
    "readme_url": "http://example.com/diaspora/diaspora-client/blob/master/README.md",
    "tag_list": [
      "example",
      "disapora client"
    ],
    "owner": {
      "id": 3,
      "name": "Diaspora",
      "created_at": "2013-09-30T13:46:02.000Z"
    },
    "name": "Diaspora Client",
    "name_with_namespace": "Diaspora / Diaspora Client",
    "path": "diaspora-client",
    "path_with_namespace": "diaspora/diaspora-client",
    "issues_enabled": true,
    "open_issues_count": 1,
    "merge_requests_enabled": true,
    "jobs_enabled": true,
    "wiki_enabled": true,
    "snippets_enabled": false,
    "resolve_outdated_diff_discussions": false,
    "container_registry_enabled": false,
    "created_at": "2013-09-30T13:46:02.000Z",
    "last_activity_at": "2013-09-30T13:46:02.000Z",
    "creator_id": 3,
    "namespace": {
      "id": 3,
      "name": "Diaspora",
      "path": "diaspora",
      "kind": "group",
      "full_path": "diaspora"
    },
    "import_status": "none",
    "archived": false,
    "avatar_url": "http://example.com/uploads/project/avatar/4/uploads/avatar.png",
    "shared_runners_enabled": true,
    "forks_count": 0,
    "star_count": 0,
    "runners_token": "b8547b1dc37721d05889db52fa2f02",
    "public_jobs": true,
    "shared_with_groups": [],
    "only_allow_merge_if_pipeline_succeeds": false,
    "only_allow_merge_if_all_discussions_are_resolved": false,
    "request_access_enabled": false,
    "merge_method": "merge",
    "statistics": {
      "commit_count": 37,
      "storage_size": 1038090,
      "repository_size": 1038090,
      "lfs_objects_size": 0,
      "job_artifacts_size": 0
    },
    "_links": {
      "self": "http://example.com/api/v4/projects",
      "issues": "http://example.com/api/v4/projects/1/issues",
      "merge_requests": "http://example.com/api/v4/projects/1/merge_requests",
      "repo_branches": "http://example.com/api/v4/projects/1/repository_branches",
      "labels": "http://example.com/api/v4/projects/1/labels",
      "events": "http://example.com/api/v4/projects/1/events",
      "members": "http://example.com/api/v4/projects/1/members"
    }
  }
""".data()

  public static let linksData = """
{
"self": "http://example.com/api/v4/projects",
"issues": "http://example.com/api/v4/projects/1/issues",
"merge_requests": "http://example.com/api/v4/projects/1/merge_requests",
"repo_branches": "http://example.com/api/v4/projects/1/repository_branches",
"labels": "http://example.com/api/v4/projects/1/labels",
"events": "http://example.com/api/v4/projects/1/events",
"members": "http://example.com/api/v4/projects/1/members"
}
""".data()

  public static let statisticsData = """
{
      "commit_count": 37,
      "storage_size": 1038090,
      "repository_size": 1038090,
      "lfs_objects_size": 0,
      "job_artifacts_size": 0
    }
""".data()

  public static let namespaceData = """
{
      "id": 3,
      "name": "Diaspora",
      "path": "diaspora",
      "kind": "group",
      "full_path": "diaspora"
    }
""".data()

  public static let userData = """
{
  "id": 3,
  "name": "Diaspora",
  "created_at": "2013-09-30T13:46:02.000Z"
}
""".data()

  public static let hookData = """
{
"id": 1,
"url": "http://example.com/hook",
"project_id": 3,
"push_events": true,
"push_events_branch_filter": "",
"issues_events": true,
"confidential_issues_events": true,
"merge_requests_events": true,
"tag_push_events": true,
"note_events": true,
"job_events": true,
"pipeline_events": true,
"wiki_page_events": true,
"enable_ssl_verification": true,
"created_at": "2012-10-12T17:04:47.000Z"
}
""".data()

  public static let languagesData = """
{
  "Ruby": 66.69,
  "JavaScript": 22.98,
  "HTML": 7.91,
  "CoffeeScript": 2.42
}
""".data()
}
