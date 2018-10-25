//
//  CommitsMocks.swift
//  RxGitLabKit-iOSTests
//
//  Created by Dagy Tran on 21/10/2018.
//

import Foundation
import RxGitLabKit

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
  
  static let newCommitMock = NewCommit(branch: "master", commitMessage: "some commit message",  actions: [
    Action(action: "create", filePath: "foo/bar", content: "some content"),
    Action(action: "delete", filePath: "foo/bar2"),
    Action(action: "move", filePath: "foo/bar3", previousPath: "foo/bar4", content: "some content"),
    Action(action: "update", filePath: "foo/bar5", content: "new content"),
    Action(action: "chmod", filePath: "foo/bar5", executeFileMode: true),
    ])
  
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
  "message": "Feature added\\n\\nSigned-off-by: Dmitriy Zaporozhets <dmitriy.zaporozhets@gmail.com>\\n",
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
  
  static let commentsData = """
[
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
]
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
  
  static let mergeRequestsData = """
[
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
   }]
""".data()
  
  
  static let commitJSONs: [String] = [
    """
    {
      "id": "53cd723d40d05177e790c8c34c36cec7092a6106",
      "short_id": "53cd723d",
      "title": "Improves scheduler tests.",
      "created_at": "2018-06-21T22:01:33.000Z",
      "parent_ids": ["ff7746caadc9ba6b8b61b973d08a311b6e779acd"],
      "message": "Improves scheduler tests.\\n",
      "author_name": "Krunoslav Zaher",
      "author_email": "krunoslav.zaher@gmail.com",
      "authored_date": "2018-06-21T22:01:33.000Z",
      "committer_name": "Krunoslav Zaher",
      "committer_email": "krunoslav.zaher@gmail.com",
      "committed_date": "2018-06-21T22:01:33.000Z"
    }
    """,
    """
    {
    "id": "ff7746caadc9ba6b8b61b973d08a311b6e779acd",
    "short_id": "ff7746ca",
    "title": "Merge pull request #1680 from ened/operation-queue-scheduler-priorities",
    "created_at": "2018-06-21T21:54:37.000Z",
    "parent_ids": ["5469535b961798efbbda6882019b1209acd25ec2", "e99c417a5e9d72877f018ea0ff5088c993567ed8"],
    "message": "Merge pull request #1680 from ened/operation-queue-scheduler-priorities\\n\\nAllow specifying a queue priority on OperationQueueScheduler",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-21T21:54:37.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-21T21:54:37.000Z"
    }
    """,
    """
    {
    "id": "e99c417a5e9d72877f018ea0ff5088c993567ed8",
    "short_id": "e99c417a",
    "title": "Merge branch 'develop' into operation-queue-scheduler-priorities",
    "created_at": "2018-06-21T21:54:28.000Z",
    "parent_ids": ["65a64b2e98289fbc2f7cc5e9175ba794175e6b9b", "5469535b961798efbbda6882019b1209acd25ec2"],
    "message": "Merge branch 'develop' into operation-queue-scheduler-priorities",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-21T21:54:28.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-21T21:54:28.000Z"
    }
    """,
    """
    {
    "id": "5469535b961798efbbda6882019b1209acd25ec2",
    "short_id": "5469535b",
    "title": "Merge pull request #1661 from hmlongco/Reduce-Bag-dispatch-implementation-code-size",
    "created_at": "2018-06-21T21:45:58.000Z",
    "parent_ids": ["261c463772ebc9232ca9f63f7b0f488109b9b65b", "826ec295c9fc96d861a9e90cb706ee9769803565"],
    "message": "Merge pull request #1661 from hmlongco/Reduce-Bag-dispatch-implementation-code-size\\n\\nReduce Bag dispatch implementation code size",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-21T21:45:58.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-21T21:45:58.000Z"
    }
    """,
    """
    {
    "id": "826ec295c9fc96d861a9e90cb706ee9769803565",
    "short_id": "826ec295",
    "title": "Merge branch 'develop' into Reduce-Bag-dispatch-implementation-code-size",
    "created_at": "2018-06-21T21:45:37.000Z",
    "parent_ids": ["a6e7ec4aac8a9e34ea825aeb81e6c2fd894801da", "261c463772ebc9232ca9f63f7b0f488109b9b65b"],
    "message": "Merge branch 'develop' into Reduce-Bag-dispatch-implementation-code-size",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-21T21:45:37.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-21T21:45:37.000Z"
    }
    """,
    """
    {
    "id": "65a64b2e98289fbc2f7cc5e9175ba794175e6b9b",
    "short_id": "65a64b2e",
    "title": "Allow specifying a queue priority on OperationQueueScheduler",
    "created_at": "2018-06-18T07:27:30.000Z",
    "parent_ids": ["261c463772ebc9232ca9f63f7b0f488109b9b65b"],
    "message": "Allow specifying a queue priority on OperationQueueScheduler\\n",
    "author_name": "Sebastian Roth",
    "author_email": "sebastian.roth@gmail.com",
    "authored_date": "2018-06-18T06:38:06.000Z",
    "committer_name": "Sebastian Roth",
    "committer_email": "sebastian.roth@gmail.com",
    "committed_date": "2018-06-18T07:27:30.000Z"
    }
    """,
    """
    {
    "id": "261c463772ebc9232ca9f63f7b0f488109b9b65b",
    "short_id": "261c4637",
    "title": "Regenerate main tests file after fix.",
    "created_at": "2018-06-17T17:31:22.000Z",
    "parent_ids": ["df4d74ac9f6ba4037052b5fc1daeee9ee973c3e1"],
    "message": "Regenerate main tests file after fix.\\n",
    "author_name": "Michael Long",
    "author_email": "mlong@clientresourcesinc.com",
    "authored_date": "2018-06-17T14:50:29.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-17T17:31:22.000Z"
    }
    """,
    """
    {
    "id": "df4d74ac9f6ba4037052b5fc1daeee9ee973c3e1",
    "short_id": "df4d74ac",
    "title": "Fix package-spm.swift order generation issue",
    "created_at": "2018-06-17T17:31:22.000Z",
    "parent_ids": ["98d523060af1d1912850af296d8e8d28abf4459e"],
    "message": "Fix package-spm.swift order generation issue\\n",
    "author_name": "Michael Long",
    "author_email": "mlong@clientresourcesinc.com",
    "authored_date": "2018-06-17T14:49:58.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-17T17:31:22.000Z"
    }
    """,
    """
    {
    "id": "98d523060af1d1912850af296d8e8d28abf4459e",
    "short_id": "98d52306",
    "title": "Merge pull request #1671 from twittemb/fix/driveDocumentation",
    "created_at": "2018-06-14T15:22:34.000Z",
    "parent_ids": ["faeb158ce76d355f3f9242fdd0258a9face62f37", "76eb80a5ee494ebc97c9a76e7493e19c1683ed45"],
    "message": "Merge pull request #1671 from twittemb/fix/driveDocumentation\\n\\nFix documentation for drive function",
    "author_name": "Shai Mishali",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-06-14T15:22:34.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-14T15:22:34.000Z"
    }
    """,
    """
    {
    "id": "76eb80a5ee494ebc97c9a76e7493e19c1683ed45",
    "short_id": "76eb80a5",
    "title": "Fix documentation for drive function",
    "created_at": "2018-06-13T23:13:58.000Z",
    "parent_ids": ["faeb158ce76d355f3f9242fdd0258a9face62f37"],
    "message": "Fix documentation for drive function\\n\\nThis commit replaces the 'variable' references for 2 'drive' functions\\nby 'relay' references.\\n",
    "author_name": "Thibault Wittemberg",
    "author_email": "thibault.wittemberg@gmail.com",
    "authored_date": "2018-06-13T23:13:58.000Z",
    "committer_name": "Thibault Wittemberg",
    "committer_email": "thibault.wittemberg@gmail.com",
    "committed_date": "2018-06-13T23:13:58.000Z"
    }
    """,
    """
    {
    "id": "faeb158ce76d355f3f9242fdd0258a9face62f37",
    "short_id": "faeb158c",
    "title": "Polish for CHANGELOG.",
    "created_at": "2018-06-08T19:19:33.000Z",
    "parent_ids": ["15a34513533af678b5ed8e9a65c081c6819894d9"],
    "message": "Polish for CHANGELOG.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T19:19:33.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T19:19:33.000Z"
    }
    """,
    """
    {
    "id": "15a34513533af678b5ed8e9a65c081c6819894d9",
    "short_id": "15a34513",
    "title": "4.2.0 Release",
    "created_at": "2018-06-08T18:32:02.000Z",
    "parent_ids": ["25b0e4c90fa2bb1a16b8e46c5d2f32eb34c2fcc1"],
    "message": "4.2.0 Release\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T12:11:46.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:32:02.000Z"
    }
    """,
    """
    {
    "id": "25b0e4c90fa2bb1a16b8e46c5d2f32eb34c2fcc1",
    "short_id": "25b0e4c9",
    "title": "Adds teardown timeout to catch crashes.",
    "created_at": "2018-06-08T18:32:02.000Z",
    "parent_ids": ["0c54cc4410afd4e2ecf71e5edf6f8f64c89a8cf0"],
    "message": "Adds teardown timeout to catch crashes.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T18:31:34.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:32:02.000Z"
    }
    """,
    """
    {
    "id": "0c54cc4410afd4e2ecf71e5edf6f8f64c89a8cf0",
    "short_id": "0c54cc44",
    "title": "Fixes deprecations.",
    "created_at": "2018-06-08T18:19:03.000Z",
    "parent_ids": ["d46f22254bdc5a475724505e83463c4c40882fad"],
    "message": "Fixes deprecations.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T18:18:31.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:19:03.000Z"
    }
    """,
    """
    {
    "id": "d46f22254bdc5a475724505e83463c4c40882fad",
    "short_id": "d46f2225",
    "title": "Changes configurations order.",
    "created_at": "2018-06-08T18:16:29.000Z",
    "parent_ids": ["0c73df21b9eecef5e36c7646368e87415310e07e"],
    "message": "Changes configurations order.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T18:15:59.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:16:29.000Z"
    }
    """,
    """
    {
    "id": "0c73df21b9eecef5e36c7646368e87415310e07e",
    "short_id": "0c73df21",
    "title": "Fixes a memory leak.",
    "created_at": "2018-06-08T18:16:29.000Z",
    "parent_ids": ["2eab35c074f55684ad91f1184916dc3a43de862f"],
    "message": "Fixes a memory leak.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T18:14:47.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:16:29.000Z"
    }
    """,
    """
    {
    "id": "2eab35c074f55684ad91f1184916dc3a43de862f",
    "short_id": "2eab35c0",
    "title": "Fixes issue with Xcode 9.4",
    "created_at": "2018-06-08T18:16:29.000Z",
    "parent_ids": ["7ecb3d5771397f74c0826125b59ac3e0f86bfd79"],
    "message": "Fixes issue with Xcode 9.4\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T17:26:32.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T18:16:29.000Z"
    }
    """,
    """
    {
    "id": "7ecb3d5771397f74c0826125b59ac3e0f86bfd79",
    "short_id": "7ecb3d57",
    "title": "Fix project warnings",
    "created_at": "2018-06-08T08:33:05.000Z",
    "parent_ids": ["2e3f6b4b8ac9fc09e312e721096c47a49ee9d12d"],
    "message": "Fix project warnings\\n",
    "author_name": "freak4pc",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-05-23T16:34:13.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T08:33:05.000Z"
    }
    """,
    """
    {
    "id": "2e3f6b4b8ac9fc09e312e721096c47a49ee9d12d",
    "short_id": "2e3f6b4b",
    "title": "Switch flatMap to compactMap",
    "created_at": "2018-06-08T08:33:05.000Z",
    "parent_ids": ["c5078ecd1b5638630e13d4f96572ffc2e62c4499"],
    "message": "Switch flatMap to compactMap\\n",
    "author_name": "freak4pc",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-05-23T16:32:09.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T08:33:05.000Z"
    }
    """,
    """
    {
    "id": "c5078ecd1b5638630e13d4f96572ffc2e62c4499",
    "short_id": "c5078ecd",
    "title": "Reachability: Use Swift 4.1 syntax for targeting simulator",
    "created_at": "2018-06-08T08:33:05.000Z",
    "parent_ids": ["bc5618fbf280519ba33ad94dcb6b92abf4da0c14"],
    "message": "Reachability: Use Swift 4.1 syntax for targeting simulator\\n",
    "author_name": "freak4pc",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-05-23T16:32:02.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T08:33:05.000Z"
    }
    """,
    """
    {
    "id": "bc5618fbf280519ba33ad94dcb6b92abf4da0c14",
    "short_id": "bc5618fb",
    "title": "Fix shareReplay syntax",
    "created_at": "2018-06-08T08:33:05.000Z",
    "parent_ids": ["1ce28ba4a6a361f98e9ee806963645350c7d3411"],
    "message": "Fix shareReplay syntax\\n",
    "author_name": "freak4pc",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-05-23T16:31:49.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T08:33:05.000Z"
    }
    """,
    """
    {
    "id": "1ce28ba4a6a361f98e9ee806963645350c7d3411",
    "short_id": "1ce28ba4",
    "title": "Fixes CI.",
    "created_at": "2018-06-08T06:58:27.000Z",
    "parent_ids": ["147417483c2b82214f023096712cd25e831c4c61"],
    "message": "Fixes CI.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T06:58:27.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T06:58:27.000Z"
    }
    """,
    """
    {
    "id": "147417483c2b82214f023096712cd25e831c4c61",
    "short_id": "14741748",
    "title": "Updates linux tests.",
    "created_at": "2018-06-08T06:58:14.000Z",
    "parent_ids": ["6e040a4f6b0c3d0712b7e11ef48c7f71c630bfc0"],
    "message": "Updates linux tests.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-08T06:58:14.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-08T06:58:14.000Z"
    }
    """,
    """
    {
    "id": "6e040a4f6b0c3d0712b7e11ef48c7f71c630bfc0",
    "short_id": "6e040a4f",
    "title": "Updates to Xcode 9.4",
    "created_at": "2018-06-07T20:30:33.000Z",
    "parent_ids": ["50195ff797cea62fb4b3c51fed080870e4233148"],
    "message": "Updates to Xcode 9.4\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-07T20:04:25.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T20:30:33.000Z"
    }
    """,
    """
    {
    "id": "50195ff797cea62fb4b3c51fed080870e4233148",
    "short_id": "50195ff7",
    "title": "Merge pull request #1634 from FuYouFang/develop",
    "created_at": "2018-06-07T19:48:16.000Z",
    "parent_ids": ["c888528d0ec6b956203b9e8150933dce5a7e74c7", "081a064638fa9c53b1cacaa69bc74504f7a91dfe"],
    "message": "Merge pull request #1634 from FuYouFang/develop\\n\\nModifmisspellings",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-07T19:48:16.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-07T19:48:16.000Z"
    }
    """,
    """
    {
    "id": "081a064638fa9c53b1cacaa69bc74504f7a91dfe",
    "short_id": "081a0646",
    "title": "Merge branch 'doc_updates' into develop",
    "created_at": "2018-06-07T19:47:27.000Z",
    "parent_ids": ["a781fde554650580aeaaba6a9988ce21617f7314", "c888528d0ec6b956203b9e8150933dce5a7e74c7"],
    "message": "Merge branch 'doc_updates' into develop",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-06-07T19:47:27.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-07T19:47:27.000Z"
    }
    """,
    """
    {
    "id": "c888528d0ec6b956203b9e8150933dce5a7e74c7",
    "short_id": "c888528d",
    "title": "Single.asCompletable uses ignoreElements operator",
    "created_at": "2018-06-07T19:39:01.000Z",
    "parent_ids": ["ae9b6c177aee7fd1d26fbba9582805a36cfd09be"],
    "message": "Single.asCompletable uses ignoreElements operator\\n",
    "author_name": "Pietro Caselani",
    "author_email": "pc1992@gmail.com",
    "authored_date": "2018-05-23T11:34:23.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T19:39:01.000Z"
    }
    """,
    """
    {
    "id": "ae9b6c177aee7fd1d26fbba9582805a36cfd09be",
    "short_id": "ae9b6c17",
    "title": "Test Single.asCompletable emitting error",
    "created_at": "2018-06-07T19:39:01.000Z",
    "parent_ids": ["8aafc7bad091d6f1184c0b1b5d0c3212616e7e1c"],
    "message": "Test Single.asCompletable emitting error\\n",
    "author_name": "Pietro Caselani",
    "author_email": "pc1992@gmail.com",
    "authored_date": "2018-05-12T20:17:55.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T19:39:01.000Z"
    }
    """,
    """
    {
    "id": "8aafc7bad091d6f1184c0b1b5d0c3212616e7e1c",
    "short_id": "8aafc7ba",
    "title": "Add operator asCompletable on Single trait",
    "created_at": "2018-06-07T19:39:01.000Z",
    "parent_ids": ["9ed05aadd75fc2753139acc895c8033eac7a928f"],
    "message": "Add operator asCompletable on Single trait\\n",
    "author_name": "Pietro Caselani",
    "author_email": "pc1992@gmail.com",
    "authored_date": "2018-05-12T19:23:36.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T19:39:01.000Z"
    }
    """,
    """
    {
    "id": "9ed05aadd75fc2753139acc895c8033eac7a928f",
    "short_id": "9ed05aad",
    "title": "* Update `ignoreElements` comment.",
    "created_at": "2018-06-07T19:32:55.000Z",
    "parent_ids": ["0d40cb45d9cd51955dbcaf48cd680c31cce3a394"],
    "message": "* Update `ignoreElements` comment.\\n",
    "author_name": "fuyoufang",
    "author_email": "fuyoufang@163.com",
    "authored_date": "2018-05-09T13:03:17.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T19:32:55.000Z"
    }
    """,
    """
    {
    "id": "0d40cb45d9cd51955dbcaf48cd680c31cce3a394",
    "short_id": "0d40cb45",
    "title": "Rename deprecated UIBindingObserver to Binder",
    "created_at": "2018-06-07T19:31:21.000Z",
    "parent_ids": ["e9066cc43fbe49f41a52dc3a6be6e06179c4324b"],
    "message": "Rename deprecated UIBindingObserver to Binder\\n",
    "author_name": "Marcin Chojnacki",
    "author_email": "marcin.chojnacki@droidsonroids.pl",
    "authored_date": "2018-05-10T06:10:49.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-06-07T19:31:21.000Z"
    }
    """,
    """
    {
    "id": "e9066cc43fbe49f41a52dc3a6be6e06179c4324b",
    "short_id": "e9066cc4",
    "title": "Merge pull request #1664 from mansi-cherry/patch-2",
    "created_at": "2018-06-05T19:11:05.000Z",
    "parent_ids": ["99b4be362bffe0882c855503ebd4f38f70526fca", "a03648b0f961433028ef8662a67ab20290e5e2e0"],
    "message": "Merge pull request #1664 from mansi-cherry/patch-2\\n\\nUpdated Getting Started Doc",
    "author_name": "Jeon Suyeol",
    "author_email": "devxoul@gmail.com",
    "authored_date": "2018-06-05T19:11:05.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-05T19:11:05.000Z"
    }
    """,
    """
    {
    "id": "a03648b0f961433028ef8662a67ab20290e5e2e0",
    "short_id": "a03648b0",
    "title": "Updated Getting Started Doc",
    "created_at": "2018-06-01T05:26:09.000Z",
    "parent_ids": ["99b4be362bffe0882c855503ebd4f38f70526fca"],
    "message": "Updated Getting Started Doc\\n\\nFixed Grammar error",
    "author_name": "Mansi Shah",
    "author_email": "32437807+mansi-cherry@users.noreply.github.com",
    "authored_date": "2018-06-01T05:26:09.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-06-01T05:26:09.000Z"
    }
    """,
    """
    {
    "id": "a6e7ec4aac8a9e34ea825aeb81e6c2fd894801da",
    "short_id": "a6e7ec4a",
    "title": "Add additional benchmarks performance test",
    "created_at": "2018-05-28T14:47:36.000Z",
    "parent_ids": ["d4d30d46d697159fe32ada1f9c47fdc2fcdb7bba"],
    "message": "Add additional benchmarks performance test\\n",
    "author_name": "Michael Long",
    "author_email": "mlong@clientresourcesinc.com",
    "authored_date": "2018-05-28T14:47:36.000Z",
    "committer_name": "Michael Long",
    "committer_email": "mlong@clientresourcesinc.com",
    "committed_date": "2018-05-28T14:47:36.000Z"
    }
    """,
    """
    {
    "id": "d4d30d46d697159fe32ada1f9c47fdc2fcdb7bba",
    "short_id": "d4d30d46",
    "title": "Update changelog for Reduce Bag dispatch implementation code size",
    "created_at": "2018-05-28T14:47:07.000Z",
    "parent_ids": ["ecd34dd6fcac6d26021d892089b93ca6a8d87040"],
    "message": "Update changelog for Reduce Bag dispatch implementation code size\\n",
    "author_name": "Michael Long",
    "author_email": "mlong@clientresourcesinc.com",
    "authored_date": "2018-05-28T14:47:07.000Z",
    "committer_name": "Michael Long",
    "committer_email": "mlong@clientresourcesinc.com",
    "committed_date": "2018-05-28T14:47:07.000Z"
    }
    """,
    """
    {
    "id": "ecd34dd6fcac6d26021d892089b93ca6a8d87040",
    "short_id": "ecd34dd6",
    "title": "Reduce Bag dispatch implementation code size",
    "created_at": "2018-05-28T14:39:42.000Z",
    "parent_ids": ["99b4be362bffe0882c855503ebd4f38f70526fca"],
    "message": "Reduce Bag dispatch implementation code size\\n",
    "author_name": "Michael Long",
    "author_email": "mlong@clientresourcesinc.com",
    "authored_date": "2018-05-28T14:39:42.000Z",
    "committer_name": "Michael Long",
    "committer_email": "mlong@clientresourcesinc.com",
    "committed_date": "2018-05-28T14:39:42.000Z"
    }
    """,
    """
    {
    "id": "99b4be362bffe0882c855503ebd4f38f70526fca",
    "short_id": "99b4be36",
    "title": "Escape wayward * in Getting Started regex example",
    "created_at": "2018-05-12T14:05:35.000Z",
    "parent_ids": ["0f49a22ebbfcb67cab5d20c4394e928582253437"],
    "message": "Escape wayward * in Getting Started regex example\\n",
    "author_name": "Garth Snyder",
    "author_email": "garth@garthsnyder.com",
    "authored_date": "2018-05-11T22:18:59.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-05-12T14:05:35.000Z"
    }
    """,
    """
    {
    "id": "a781fde554650580aeaaba6a9988ce21617f7314",
    "short_id": "a781fde5",
    "title": "Fixes various spelling mistakes and missing parameters.",
    "created_at": "2018-05-07T09:55:07.000Z",
    "parent_ids": ["0f49a22ebbfcb67cab5d20c4394e928582253437"],
    "message": "Fixes various spelling mistakes and missing parameters.\\n",
    "author_name": "fuyoufang",
    "author_email": "fuyoufang@163.com",
    "authored_date": "2018-05-07T09:55:07.000Z",
    "committer_name": "fuyoufang",
    "committer_email": "fuyoufang@163.com",
    "committed_date": "2018-05-07T09:55:07.000Z"
    }
    """,
    """
    {
    "id": "0f49a22ebbfcb67cab5d20c4394e928582253437",
    "short_id": "0f49a22e",
    "title": "Remove redundant word",
    "created_at": "2018-04-24T10:50:38.000Z",
    "parent_ids": ["14390b859c224b2191f400deb32ef97df010ea74"],
    "message": "Remove redundant word\\n\\nRemoved a redundant \'the\'",
    "author_name": "Isaac Halvorson",
    "author_email": "hello@hisaac.net",
    "authored_date": "2018-04-23T16:23:23.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-24T10:50:38.000Z"
    }
    """,
    """
    {
    "id": "14390b859c224b2191f400deb32ef97df010ea74",
    "short_id": "14390b85",
    "title": "Modify the misspelling of `additional`",
    "created_at": "2018-04-18T06:33:38.000Z",
    "parent_ids": ["30e1d3008423be616910db5f588afe70880d8624"],
    "message": "Modify the misspelling of `additional`\\n",
    "author_name": "fuyoufang",
    "author_email": "fuyoufang@163.com",
    "authored_date": "2018-04-18T00:52:39.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-18T06:33:38.000Z"
    }
    """,
    """
    {
    "id": "30e1d3008423be616910db5f588afe70880d8624",
    "short_id": "30e1d300",
    "title": "Comment error",
    "created_at": "2018-04-17T13:08:12.000Z",
    "parent_ids": ["0aa07a6b266edbfb84ee052bab3f2408c2364e03"],
    "message": "Comment error\\n",
    "author_name": "fuyoufang",
    "author_email": "fuyoufang@163.com",
    "authored_date": "2018-04-17T12:58:28.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-17T13:08:12.000Z"
    }
    """,
    """
    {
    "id": "0aa07a6b266edbfb84ee052bab3f2408c2364e03",
    "short_id": "0aa07a6b",
    "title": "Add operator `flatMapCompletable` on Single trait",
    "created_at": "2018-04-13T07:23:40.000Z",
    "parent_ids": ["7d8743d82e31f8650c83258b84c4694043e64caa"],
    "message": "Add operator `flatMapCompletable` on Single trait\\n",
    "author_name": "Pietro Caselani",
    "author_email": "pc1992@gmail.com",
    "authored_date": "2018-03-19T14:21:34.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-13T07:23:40.000Z"
    }
    """,
    """
    {
    "id": "7d8743d82e31f8650c83258b84c4694043e64caa",
    "short_id": "7d8743d8",
    "title": "Update Bag.swift comment",
    "created_at": "2018-04-13T07:19:53.000Z",
    "parent_ids": ["ba41245d067af562c6e61b9439ea1686c1fb60ad"],
    "message": "Update Bag.swift comment\\n\\nThere is maybe a mistake icomments at line 28. Please check it.",
    "author_name": "jin_ai_yuan",
    "author_email": "jinaiyuanbaojie@163.com",
    "authored_date": "2018-04-12T08:20:42.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-13T07:19:53.000Z"
    }
    """,
    """
    {
    "id": "ba41245d067af562c6e61b9439ea1686c1fb60ad",
    "short_id": "ba41245d",
    "title": "Fixes for Xcode9.3",
    "created_at": "2018-04-04T18:06:29.000Z",
    "parent_ids": ["52307b082cd5a615576452bfdbe8262de4c1f839"],
    "message": "Fixes for Xcode9.3\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-04T14:10:07.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-04T18:06:29.000Z"
    }
    """,
    """
    {
    "id": "52307b082cd5a615576452bfdbe8262de4c1f839",
    "short_id": "52307b08",
    "title": "Reverts Xcode 9.3.",
    "created_at": "2018-04-04T13:15:58.000Z",
    "parent_ids": ["0c14d7498cfb431afd87aca951b792d15b7e0bb4"],
    "message": "Reverts Xcode 9.3.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-04T13:15:58.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-04T13:15:58.000Z"
    }
    """,
    """
    {
    "id": "0c14d7498cfb431afd87aca951b792d15b7e0bb4",
    "short_id": "0c14d749",
    "title": "Adds equatable definition.",
    "created_at": "2018-04-04T12:42:18.000Z",
    "parent_ids": ["c01605051e7bb0b52c204ed226a4b8314f2e7fe2"],
    "message": "Adds equatable definition.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-04T12:42:18.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-04T12:42:18.000Z"
    }
    """,
    """
    {
    "id": "c01605051e7bb0b52c204ed226a4b8314f2e7fe2",
    "short_id": "c0160505",
    "title": "Merge branch 'master' into develop",
    "created_at": "2018-04-04T12:38:24.000Z",
    "parent_ids": ["6150cc902de6f5bcd34fee67592ae73b2eea8f87", "e5093a1273bd106262a8fe0e6a614dba9a293bc3"],
    "message": "Merge branch 'master' into develop\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-04T12:38:24.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-04T12:38:24.000Z"
    }
    """,
    """
    {
    "id": "6150cc902de6f5bcd34fee67592ae73b2eea8f87",
    "short_id": "6150cc90",
    "title": "Fixes for Xcode 9.3",
    "created_at": "2018-04-04T12:19:31.000Z",
    "parent_ids": ["5227467d436c7bf18c274627654f57cfce188122"],
    "message": "Fixes for Xcode 9.3\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-04T12:19:31.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-04T12:19:31.000Z"
    }
    """,
    """
    {
    "id": "5227467d436c7bf18c274627654f57cfce188122",
    "short_id": "5227467d",
    "title": "Sets CI environment version to Xcode 9.3",
    "created_at": "2018-04-03T12:47:44.000Z",
    "parent_ids": ["a664f42efe79ced02a493a69d1eb8d1f276a8cce"],
    "message": "Sets CI environment version to Xcode 9.3\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-04-03T12:47:44.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-04-03T12:47:44.000Z"
    }
    """,
    """
    {
    "id": "a664f42efe79ced02a493a69d1eb8d1f276a8cce",
    "short_id": "a664f42e",
    "title": "Merge pull request #1599 from alanzeino/41",
    "created_at": "2018-04-03T09:33:04.000Z",
    "parent_ids": ["b26ce9aab8750b9b564d5dba7a94469317da8799", "f3305e92e5725f0fb6815f9e5366d29b2dc1b290"],
    "message": "Merge pull request #1599 from alanzeino/41\\n\\nUpdatCurrentThreadScheduler.swift for Swift 4.1",
    "author_name": "Shai Mishali",
    "author_email": "freak4pc@gmail.com",
    "authored_date": "2018-04-03T09:33:04.000Z",
    "committer_name": "GitHub",
    "committer_email": "noreply@github.com",
    "committed_date": "2018-04-03T09:33:04.000Z"
    }
    """,
    """
    {
    "id": "e5093a1273bd106262a8fe0e6a614dba9a293bc3",
    "short_id": "e5093a12",
    "title": "Fixes #1603",
    "created_at": "2018-03-29T23:24:58.000Z",
    "parent_ids": ["4431b623751ac5525e8a8c2d6e82f29b983af07c"],
    "message": "Fixes #1603\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-03-29T23:24:58.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-29T23:24:58.000Z"
    }
    """,
    """
    {
    "id": "b26ce9aab8750b9b564d5dba7a94469317da8799",
    "short_id": "b26ce9aa",
    "title": "renaming enabled(forSegmentAt: ), title(forSegmentAt: ) and image(forSegmentAt:…",
    "created_at": "2018-03-26T08:50:48.000Z",
    "parent_ids": ["c731acd42b0db035e6c049067246903d3af67dfb"],
    "message": "renaming enabled(forSegmentAt: ), title(forSegmentAt: ) and image(forSegmentAt: ) and deprecate renaming enabled(forSegmentAt: ) to enabledForSegment(at:)\\n",
    "author_name": "Luciano",
    "author_email": "passos.luciano@outlook.com",
    "authored_date": "2018-03-24T04:03:11.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-26T08:50:48.000Z"
    }
    """,
    """
    {
    "id": "c731acd42b0db035e6c049067246903d3af67dfb",
    "short_id": "c731acd4",
    "title": "UISegmentedControl set title and image for segment wrappers.",
    "created_at": "2018-03-26T08:50:48.000Z",
    "parent_ids": ["4431b623751ac5525e8a8c2d6e82f29b983af07c"],
    "message": "UISegmentedControl set title and image for segment wrappers.\\n",
    "author_name": "Luciano",
    "author_email": "passos.luciano@outlook.com",
    "authored_date": "2018-03-12T19:15:08.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-26T08:50:48.000Z"
    }
    """,
    """
    {
    "id": "4431b623751ac5525e8a8c2d6e82f29b983af07c",
    "short_id": "4431b623",
    "title": "Updates SPM.",
    "created_at": "2018-03-17T10:43:34.000Z",
    "parent_ids": ["4d79760cf0943cc0f92136ae2cdab4cd8fd01b95"],
    "message": "Updates SPM.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-03-17T10:43:34.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-17T10:43:34.000Z"
    }
    """,
    """
    {
    "id": "4d79760cf0943cc0f92136ae2cdab4cd8fd01b95",
    "short_id": "4d79760c",
    "title": "Improves change detection script.",
    "created_at": "2018-03-17T10:42:46.000Z",
    "parent_ids": ["10857c2d88cf886fb2d008246bef2dfdc4d31590"],
    "message": "Improves change detection script.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-03-17T10:42:46.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-17T10:42:46.000Z"
    }
    """,
    """
    {
    "id": "10857c2d88cf886fb2d008246bef2dfdc4d31590",
    "short_id": "10857c2d",
    "title": "Fixes typos #1594.",
    "created_at": "2018-03-17T10:28:16.000Z",
    "parent_ids": ["7286c9c5c64602cf3fcd9374cab41f31f29c6e71"],
    "message": "Fixes typos #1594.\\n",
    "author_name": "Krunoslav Zaher",
    "author_email": "krunoslav.zaher@gmail.com",
    "authored_date": "2018-03-17T10:28:16.000Z",
    "committer_name": "Krunoslav Zaher",
    "committer_email": "krunoslav.zaher@gmail.com",
    "committed_date": "2018-03-17T10:28:16.000Z"
    }
    """,
    """
    {
    "id": "f3305e92e5725f0fb6815f9e5366d29b2dc1b290",
    "short_id": "f3305e92",
    "title": "Update CurrentThreadScheduler.swift for Swift 4.1",
    "created_at": "2018-03-16T23:08:41.000Z",
    "parent_ids": ["21e0fb8a1e071b02b04a4acc6f0125e5ae64511d"],
    "message": "Update CurrentThreadScheduler.swift for Swift 4.1\\n",
    "author_name": "Alan Zeino",
    "author_email": "alanz@uber.com",
    "authored_date": "2018-03-16T22:30:03.000Z",
    "committer_name": "Alan Zeino",
    "committer_email": "alanz@uber.com",
    "committed_date": "2018-03-16T23:08:41.000Z"
    }
"""
  ]
  
  static let commitData: [Data] = commitJSONs.map { $0.data() }
  
  static let commits: [Commit] = commitJSONs.map { json in
    let decoder = JSONDecoder()
    return try! decoder.decode(Commit.self, from: json.data())
  }

  static var totalCommitsCount: Int {
    return commitData.count
  }
  
}
