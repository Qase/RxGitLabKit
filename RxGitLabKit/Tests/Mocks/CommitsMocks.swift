//
//  CommitsMocks.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 21/10/2018.
//

import Foundation

class CommitsMocks {
  
  static let mockProjectID = "12345"
  
  static let twoCommitsData = """
[
  {
    "id": "ed899a2f4b50b4370feeea94676502b42383c746",
    "short_id": "ed899a2f4b5",
    "title": "Replace sanitize with escape once",
    "author_name": "Dmitriy Zaporozhets",
    "author_email": "dzaporozhets@sphereconsultinginc.com",
    "authored_date": "2012-09-20T11:50:22+03:00",
    "committer_name": "Administrator",
    "committer_email": "admin@example.com",
    "committed_date": "2012-09-20T11:50:22+03:00",
    "created_at": "2012-09-20T11:50:22+03:00",
    "message": "Replace sanitize with escape once",
    "parent_ids": [
      "6104942438c14ec7bd21c6cd5bd995272b3faff6"
    ]
  },
  {
    "id": "6104942438c14ec7bd21c6cd5bd995272b3faff6",
    "short_id": "6104942438c",
    "title": "Sanitize for network graph",
    "author_name": "randx",
    "author_email": "dmitriy.zaporozhets@gmail.com",
    "committer_name": "Dmitriy",
    "committer_email": "dmitriy.zaporozhets@gmail.com",
    "created_at": "2012-09-20T09:06:12+03:00",
    "message": "Sanitize for network graph",
    "parent_ids": [
      "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
    ]
  }
]
""".data()
  
  static let newCommit = """
{
  "branch": "master",
  "commit_message": "some commit message",
  "actions": [
    {
      "action": "create",
      "file_path": "foo/bar",
      "content": "some content"
    },
    {
      "action": "delete",
      "file_path": "foo/bar2"
    },
    {
      "action": "move",
      "file_path": "foo/bar3",
      "previous_path": "foo/bar4",
      "content": "some content"
    },
    {
      "action": "update",
      "file_path": "foo/bar5",
      "content": "new content"
    },
    {
      "action": "chmod",
      "file_path": "foo/bar5",
      "execute_filemode": true
    }
  ]
}
""".data()
  
  static let newCommitResponseData = """
{
  "id": "ed899a2f4b50b4370feeea94676502b42383c746",
  "short_id": "ed899a2f4b5",
  "title": "some commit message",
  "author_name": "Dmitriy Zaporozhets",
  "author_email": "dzaporozhets@sphereconsultinginc.com",
  "committer_name": "Dmitriy Zaporozhets",
  "committer_email": "dzaporozhets@sphereconsultinginc.com",
  "created_at": "2016-09-20T09:26:24.000-07:00",
  "message": "some commit message",
  "parent_ids": [
    "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
  ],
  "committed_date": "2016-09-20T09:26:24.000-07:00",
  "authored_date": "2016-09-20T09:26:24.000-07:00",
  "stats": {
    "additions": 2,
    "deletions": 2,
    "total": 4
  },
  "status": null
}
""".data()
  
  static let singleCommitResponseData = """
{
  "id": "6104942438c14ec7bd21c6cd5bd995272b3faff6",
  "short_id": "6104942438c",
  "title": "Sanitize for network graph",
  "author_name": "randx",
  "author_email": "dmitriy.zaporozhets@gmail.com",
  "committer_name": "Dmitriy",
  "committer_email": "dmitriy.zaporozhets@gmail.com",
  "created_at": "2012-09-20T09:06:12+03:00",
  "message": "Sanitize for network graph",
  "committed_date": "2012-09-20T09:06:12+03:00",
  "authored_date": "2012-09-20T09:06:12+03:00",
  "parent_ids": [
    "ae1d9fb46aa2b07ee9836d49862ec4e2c46fbbba"
  ],
  "last_pipeline" : {
    "id": 8,
    "ref": "master",
    "sha": "2dc6aa325a317eda67812f05600bdf0fcdc70ab0",
    "status": "created"
  },
  "stats": {
    "additions": 15,
    "deletions": 10,
    "total": 25
  },
  "status": "running"
}
""".data()
  
  static let referencesResponseData = """
[
  {"type": "branch", "name": "'test'"},
  {"type": "branch", "name": "add-balsamiq-file"},
  {"type": "branch", "name": "wip"},
  {"type": "tag", "name": "v1.1.0"}
 ]
""".data()
  
  static let cherryPickResponseData = """
{
  "id": "8b090c1b79a14f2bd9e8a738f717824ff53aebad",
  "short_id": "8b090c1b",
  "title": "Feature added",
  "author_name": "Dmitriy Zaporozhets",
  "author_email": "dmitriy.zaporozhets@gmail.com",
  "authored_date": "2016-12-12T20:10:39.000+01:00",
  "created_at": "2016-12-12T20:10:39.000+01:00",
  "committer_name": "Administrator",
  "committer_email": "admin@example.com",
  "committed_date": "2016-12-12T20:10:39.000+01:00",
  "title": "Feature added",
  "message": "Feature added\n\nSigned-off-by: Dmitriy Zaporozhets <dmitriy.zaporozhets@gmail.com>\n",
  "parent_ids": [
    "a738f717824ff53aebad8b090c1b79a14f2bd9e8"
  ]
}
""".data()
  
  static let diffData = """
{
  "diff": "--- a/doc/update/5.4-to-6.0.md +++ b/doc/update/5.4-to-6.0.md @@ -71,6 +71,8 @@ sudo -u git -H bundle exec rake migrate_keys RAILS_ENV=production sudo -u git -H bundle exec rake migrate_inline_notes RAILS_ENV=production +sudo -u git -H bundle exec rake gitlab:assets:compile RAILS_ENV=production+",
  "new_path": "doc/update/5.4-to-6.0.md",
  "old_path": "doc/update/5.4-to-6.0.md",
  "a_mode": null,
  "b_mode": "100644",
  "new_file": false,
  "renamed_file": false,
  "deleted_file": false
}
""".data()
  
  static let commentData = """
{
  "note": "this code is really nice",
  "author": {
    "id": 11,
    "username": "admin",
    "email": "admin@local.host",
    "name": "Administrator",
    "state": "active",
    "created_at": "2014-03-06T08:17:35Z"
  }
}
""".data()
  
  static let commentResponseData = """
{
  "author" : {
      "web_url" : "https://gitlab.example.com/thedude",
      "avatar_url" : "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png",
      "username" : "thedude",
      "state" : "active",
      "name" : "Jeff Lebowski",
      "id" : 28
    },
  "created_at" : "2016-01-19T09:44:55Z",
  "line_type" : "new",
  "path" : "dudeism.md",
  "line" : 11,
  "note" : "Nice picture man!"
}
""".data()
  
  
  static let commitStatusesData = """
[
{
      "status" : "pending",
      "created_at" : "2016-01-19T08:40:25Z",
      "started_at" : null,
      "name" : "bundler:audit",
      "allow_failure" : true,
      "author" : {
         "username" : "thedude",
         "state" : "active",
         "web_url" : "https://gitlab.example.com/thedude",
         "avatar_url" : "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png",
         "id" : 28,
         "name" : "Jeff Lebowski"
      },
      "description" : null,
      "sha" : "18f3e63d05582537db6d183d9d557be09e1f90c8",
      "target_url" : "https://gitlab.example.com/thedude/gitlab-ce/builds/91",
      "finished_at" : null,
      "id" : 91,
      "ref" : "master"
   },
   {
      "started_at" : null,
      "name" : "test",
      "allow_failure" : false,
      "status" : "pending",
      "created_at" : "2016-01-19T08:40:25Z",
      "target_url" : "https://gitlab.example.com/thedude/gitlab-ce/builds/90",
      "id" : 90,
      "finished_at" : null,
      "ref" : "master",
      "sha" : "18f3e63d05582537db6d183d9d557be09e1f90c8",
      "author" : {
         "id" : 28,
         "name" : "Jeff Lebowski",
         "username" : "thedude",
         "web_url" : "https://gitlab.example.com/thedude",
         "state" : "active",
         "avatar_url" : "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png"
      },
      "description" : null
   }
]
""".data()
  
  
  static let buildCommitStatusResponseData = """
{
"author" : {
    "web_url" : "https://gitlab.example.com/thedude",
    "name" : "Jeff Lebowski",
    "avatar_url" : "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png",
    "username" : "thedude",
    "state" : "active",
    "id" : 28
  },
  "name" : "default",
  "sha" : "18f3e63d05582537db6d183d9d557be09e1f90c8",
  "status" : "success",
  "coverage": 100.0,
  "description" : null,
  "id" : 93,
  "target_url" : null,
  "ref" : null,
  "started_at" : null,
  "created_at" : "2016-01-19T09:05:50Z",
  "allow_failure" : false,
  "finished_at" : "2016-01-19T09:05:50Z"
}
""".data()
  
  static let mergeRequestData = """
{
      "id":45,
      "iid":1,
      "project_id":35,
      "title":"Add new file",
      "description":"",
      "state":"opened",
      "created_at":"2018-03-26T17:26:30Z",
      "updated_at":"2018-03-26T17:26:30Z",
      "target_branch":"master",
      "source_branch":"test-branch",
      "upvotes":0,
      "downvotes":0,
      "author" : {
        "web_url" : "https://gitlab.example.com/thedude",
        "name" : "Jeff Lebowski",
        "avatar_url" : "https://gitlab.example.com/uploads/user/avatar/28/The-Big-Lebowski-400-400.png",
        "username" : "thedude",
        "state" : "active",
        "id" : 28
      },
      "assignee":null,
      "source_project_id":35,
      "target_project_id":35,
      "labels":[ ],
      "work_in_progress":false,
      "milestone":null,
      "merge_when_pipeline_succeeds":false,
      "merge_status":"can_be_merged",
      "sha":"af5b13261899fb2c0db30abdd0af8b07cb44fdc5",
      "merge_commit_sha":null,
      "user_notes_count":0,
      "discussion_locked":null,
      "should_remove_source_branch":null,
      "force_remove_source_branch":false,
      "web_url":"http://https://gitlab.example.com/root/test-project/merge_requests/1",
      "time_stats":{
         "time_estimate":0,
         "total_time_spent":0,
         "human_time_estimate":1,
         "human_total_time_spent":2
      }
   }
""".data()
}
