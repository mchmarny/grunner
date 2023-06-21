# samples

## local

build: 

```shell
docker build -f samples/Dockerfile.simple -t grunner-simple .
```

run: 

```shell
docker run --rm -it --entrypoint /bin/bash docker.io/library/grunner-simple
```

## provenance

from AA:

```shell
gcloud artifacts docker images describe $digest \
    --show-provenance --format json
```

```json
{
  "image_summary": {
    "digest": "sha256:b3c77ed6a157c14ed91584f21723d5ba9bbf8ea5586e2dea5ac6ea120e3d2271",
    "fully_qualified_digest": "us-west1-docker.pkg.dev/s3cme1/grunner/simple@sha256:b3c77ed6a157c14ed91584f21723d5ba9bbf8ea5586e2dea5ac6ea120e3d2271",
    "registry": "us-west1-docker.pkg.dev",
    "repository": "grunner",
    "slsa_build_level": "unknown"
  }
}
```

from cosign attestation:

```shell
cosign download attestation $digest | jq -r .payload | base64 -d | jq -r .
```

```json
{
  "_type": "https://in-toto.io/Statement/v0.1",
  "predicateType": "https://slsa.dev/provenance/v0.2",
  "subject": [
    {
      "name": "us-west1-docker.pkg.dev/s3cme1/grunner/simple",
      "digest": {
        "sha256": "b3c77ed6a157c14ed91584f21723d5ba9bbf8ea5586e2dea5ac6ea120e3d2271"
      }
    }
  ],
  "predicate": {
    "builder": {
      "id": "https://github.com/slsa-framework/slsa-github-generator/.github/workflows/generator_container_slsa3.yml@refs/tags/v1.7.0"
    },
    "buildType": "https://github.com/slsa-framework/slsa-github-generator/container@v1",
    "invocation": {
      "configSource": {
        "uri": "git+https://github.com/mchmarny/grunner@refs/tags/v0.3.4",
        "digest": {
          "sha1": "81a7702b067f7335b5f83050c84d591651321aa8"
        },
        "entryPoint": ".github/workflows/tag.yaml"
      },
      "parameters": {},
      "environment": {
        "github_actor": "mchmarny",
        "github_actor_id": "175854",
        "github_base_ref": "",
        "github_event_name": "push",
        "github_event_payload": {
          "after": "b20d3891123f1007965e1686c7529eda8c54bd4c",
          "base_ref": null,
          "before": "0000000000000000000000000000000000000000",
          "commits": [],
          "compare": "https://github.com/mchmarny/grunner/compare/v0.3.4",
          "created": true,
          "deleted": false,
          "forced": false,
          "head_commit": {
            "author": {
              "email": "mark@chmarny.com",
              "name": "Mark Chmarny",
              "username": "mchmarny"
            },
            "committer": {
              "email": "mark@chmarny.com",
              "name": "Mark Chmarny",
              "username": "mchmarny"
            },
            "distinct": true,
            "id": "81a7702b067f7335b5f83050c84d591651321aa8",
            "message": "remove token",
            "timestamp": "2023-06-20T14:02:23-07:00",
            "tree_id": "dcb5420838dbaa537165e6c83cee906a8308c61b",
            "url": "https://github.com/mchmarny/grunner/commit/81a7702b067f7335b5f83050c84d591651321aa8"
          },
          "pusher": {
            "email": "mchmarny@users.noreply.github.com",
            "name": "mchmarny"
          },
          "ref": "refs/tags/v0.3.4",
          "repository": {
            "allow_forking": true,
            "archive_url": "https://api.github.com/repos/mchmarny/grunner/{archive_format}{/ref}",
            "archived": false,
            "assignees_url": "https://api.github.com/repos/mchmarny/grunner/assignees{/user}",
            "blobs_url": "https://api.github.com/repos/mchmarny/grunner/git/blobs{/sha}",
            "branches_url": "https://api.github.com/repos/mchmarny/grunner/branches{/branch}",
            "clone_url": "https://github.com/mchmarny/grunner.git",
            "collaborators_url": "https://api.github.com/repos/mchmarny/grunner/collaborators{/collaborator}",
            "comments_url": "https://api.github.com/repos/mchmarny/grunner/comments{/number}",
            "commits_url": "https://api.github.com/repos/mchmarny/grunner/commits{/sha}",
            "compare_url": "https://api.github.com/repos/mchmarny/grunner/compare/{base}...{head}",
            "contents_url": "https://api.github.com/repos/mchmarny/grunner/contents/{+path}",
            "contributors_url": "https://api.github.com/repos/mchmarny/grunner/contributors",
            "created_at": 1686863139,
            "default_branch": "main",
            "deployments_url": "https://api.github.com/repos/mchmarny/grunner/deployments",
            "description": "Self-hosted GitHub Actions runner on GCP using GCE.",
            "disabled": false,
            "downloads_url": "https://api.github.com/repos/mchmarny/grunner/downloads",
            "events_url": "https://api.github.com/repos/mchmarny/grunner/events",
            "fork": false,
            "forks": 0,
            "forks_count": 0,
            "forks_url": "https://api.github.com/repos/mchmarny/grunner/forks",
            "full_name": "mchmarny/grunner",
            "git_commits_url": "https://api.github.com/repos/mchmarny/grunner/git/commits{/sha}",
            "git_refs_url": "https://api.github.com/repos/mchmarny/grunner/git/refs{/sha}",
            "git_tags_url": "https://api.github.com/repos/mchmarny/grunner/git/tags{/sha}",
            "git_url": "git://github.com/mchmarny/grunner.git",
            "has_discussions": false,
            "has_downloads": true,
            "has_issues": true,
            "has_pages": false,
            "has_projects": false,
            "has_wiki": false,
            "homepage": "",
            "hooks_url": "https://api.github.com/repos/mchmarny/grunner/hooks",
            "html_url": "https://github.com/mchmarny/grunner",
            "id": 654309701,
            "is_template": true,
            "issue_comment_url": "https://api.github.com/repos/mchmarny/grunner/issues/comments{/number}",
            "issue_events_url": "https://api.github.com/repos/mchmarny/grunner/issues/events{/number}",
            "issues_url": "https://api.github.com/repos/mchmarny/grunner/issues{/number}",
            "keys_url": "https://api.github.com/repos/mchmarny/grunner/keys{/key_id}",
            "labels_url": "https://api.github.com/repos/mchmarny/grunner/labels{/name}",
            "language": "HCL",
            "languages_url": "https://api.github.com/repos/mchmarny/grunner/languages",
            "license": {
              "key": "apache-2.0",
              "name": "Apache License 2.0",
              "node_id": "MDc6TGljZW5zZTI=",
              "spdx_id": "Apache-2.0",
              "url": "https://api.github.com/licenses/apache-2.0"
            },
            "master_branch": "main",
            "merges_url": "https://api.github.com/repos/mchmarny/grunner/merges",
            "milestones_url": "https://api.github.com/repos/mchmarny/grunner/milestones{/number}",
            "mirror_url": null,
            "name": "grunner",
            "node_id": "R_kgDOJv_5RQ",
            "notifications_url": "https://api.github.com/repos/mchmarny/grunner/notifications{?since,all,participating}",
            "open_issues": 1,
            "open_issues_count": 1,
            "owner": {
              "avatar_url": "https://avatars.githubusercontent.com/u/175854?v=4",
              "email": "mchmarny@users.noreply.github.com",
              "events_url": "https://api.github.com/users/mchmarny/events{/privacy}",
              "followers_url": "https://api.github.com/users/mchmarny/followers",
              "following_url": "https://api.github.com/users/mchmarny/following{/other_user}",
              "gists_url": "https://api.github.com/users/mchmarny/gists{/gist_id}",
              "gravatar_id": "",
              "html_url": "https://github.com/mchmarny",
              "id": 175854,
              "login": "mchmarny",
              "name": "mchmarny",
              "node_id": "MDQ6VXNlcjE3NTg1NA==",
              "organizations_url": "https://api.github.com/users/mchmarny/orgs",
              "received_events_url": "https://api.github.com/users/mchmarny/received_events",
              "repos_url": "https://api.github.com/users/mchmarny/repos",
              "site_admin": false,
              "starred_url": "https://api.github.com/users/mchmarny/starred{/owner}{/repo}",
              "subscriptions_url": "https://api.github.com/users/mchmarny/subscriptions",
              "type": "User",
              "url": "https://api.github.com/users/mchmarny"
            },
            "private": false,
            "pulls_url": "https://api.github.com/repos/mchmarny/grunner/pulls{/number}",
            "pushed_at": 1687294953,
            "releases_url": "https://api.github.com/repos/mchmarny/grunner/releases{/id}",
            "size": 223,
            "ssh_url": "git@github.com:mchmarny/grunner.git",
            "stargazers": 12,
            "stargazers_count": 12,
            "stargazers_url": "https://api.github.com/repos/mchmarny/grunner/stargazers",
            "statuses_url": "https://api.github.com/repos/mchmarny/grunner/statuses/{sha}",
            "subscribers_url": "https://api.github.com/repos/mchmarny/grunner/subscribers",
            "subscription_url": "https://api.github.com/repos/mchmarny/grunner/subscription",
            "svn_url": "https://github.com/mchmarny/grunner",
            "tags_url": "https://api.github.com/repos/mchmarny/grunner/tags",
            "teams_url": "https://api.github.com/repos/mchmarny/grunner/teams",
            "topics": [
              "actions",
              "gce",
              "gcp",
              "mig",
              "runner",
              "terraform",
              "workflow"
            ],
            "trees_url": "https://api.github.com/repos/mchmarny/grunner/git/trees{/sha}",
            "updated_at": "2023-06-20T20:24:57Z",
            "url": "https://github.com/mchmarny/grunner",
            "visibility": "public",
            "watchers": 12,
            "watchers_count": 12,
            "web_commit_signoff_required": true
          },
          "sender": {
            "avatar_url": "https://avatars.githubusercontent.com/u/175854?v=4",
            "events_url": "https://api.github.com/users/mchmarny/events{/privacy}",
            "followers_url": "https://api.github.com/users/mchmarny/followers",
            "following_url": "https://api.github.com/users/mchmarny/following{/other_user}",
            "gists_url": "https://api.github.com/users/mchmarny/gists{/gist_id}",
            "gravatar_id": "",
            "html_url": "https://github.com/mchmarny",
            "id": 175854,
            "login": "mchmarny",
            "node_id": "MDQ6VXNlcjE3NTg1NA==",
            "organizations_url": "https://api.github.com/users/mchmarny/orgs",
            "received_events_url": "https://api.github.com/users/mchmarny/received_events",
            "repos_url": "https://api.github.com/users/mchmarny/repos",
            "site_admin": false,
            "starred_url": "https://api.github.com/users/mchmarny/starred{/owner}{/repo}",
            "subscriptions_url": "https://api.github.com/users/mchmarny/subscriptions",
            "type": "User",
            "url": "https://api.github.com/users/mchmarny"
          }
        },
        "github_head_ref": "",
        "github_ref": "refs/tags/v0.3.4",
        "github_ref_type": "tag",
        "github_repository_id": "654309701",
        "github_repository_owner": "mchmarny",
        "github_repository_owner_id": "175854",
        "github_run_attempt": "1",
        "github_run_id": "5327371872",
        "github_run_number": "6",
        "github_sha1": "81a7702b067f7335b5f83050c84d591651321aa8"
      }
    },
    "metadata": {
      "buildInvocationID": "5327371872-1",
      "completeness": {
        "parameters": true,
        "environment": false,
        "materials": false
      },
      "reproducible": false
    },
    "materials": [
      {
        "uri": "git+https://github.com/mchmarny/grunner@refs/tags/v0.3.4",
        "digest": {
          "sha1": "81a7702b067f7335b5f83050c84d591651321aa8"
        }
      }
    ]
  }
}
```