The repository contains a basic Github client for its REST API.

## Requirements
* Ruby 3.3.0
* Access to at least one Github repository
* Please create a personal access token for your personal account so that the Github API requests work. The repository is public, so any token will work.

## Instructions
It needs to be run at the command line like this

```
TOKEN=github_pat_xxx ruby process.rb <repository URL, like https://api.github.com/repos/user_or_organization/repo>
```
```
TOKEN=ghp_token ruby process.rb https://api.github.com/repos/paper-trail-gem/paper_trail
```

The code implements only one method in the API - `issues`. It outputs all issues in the provided repository through pagination. It lets you set whether the
issues returned are open or closed as well as items count, and then displays them in decreasing order of date as follows:

1. If you selected open issues, the date used is the issue's created date.
1. Else, it's the issues' closed date.

