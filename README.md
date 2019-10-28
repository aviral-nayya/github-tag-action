# github-tag-action

A Github Action to automatically bump and tag master, on merge, with the latest SemVer formatted version, and update `latest` tag to point to the latest commit.

[![Build Status](https://github.com/wiktorj/github-tag-action/workflows/Bump%20version/badge.svg)](https://github.com/wiktorj/github-tag-action/workflows/Bump%20version/badge.svg)
[![Stable Version](https://img.shields.io/github/v/tag/wiktorj/github-tag-action)](https://img.shields.io/github/v/tag/wiktorj/github-tag-action)
[![Latest Release](https://img.shields.io/github/v/release/wiktorj/github-tag-action?color=%233D9970)](https://img.shields.io/github/v/release/wiktorj/github-tag-action?color=%233D9970)

### Usage

```Dockerfile
name: Bump version
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Bump version and push tag
      uses: wiktorj/github-tag-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

#### Options

**Environment Variables**

* **GITHUB_TOKEN** ***(required)*** - Required for permission to tag the repo.
* **WITH_V** *(optional)* - Tag version with `v` character.

#### Outputs

* **new_tag** - The value of the newly created tag.

> ***Note:*** This action creates a [annotated tag](https://git-scm.com/book/en/v1/Git-Internals-Git-References#Tags).

### Bumping

With every commit to master `latest` tag is updated to the latest commit in the master branch. 

Any commit message that includes `#major`, `#minor`, or `#patch` will trigger the respective version bump. If two or more are present, the highest-ranking one will take precedence.


> ***Note:*** This action **will not** bump the tag if the `HEAD` commit has already been tagged.

### Workflow

* Add this action to your repo
* Commit some changes
* Either push to master or open a PR
* On push (or merge) to `master`, the action will:
  * Get latest tag (different than `latest`)
  * Bump the tag **if** commit message contains one of the: `#major`, `#minor` or `#patch` 
  * Updates `latest` tag to point to the latest commit on the master branch
  * Pushes tags updates to github

### Credits

[fsaintjacques/semver-tool](https://github.com/fsaintjacques/semver-tool)

[anothrNick/github-tag-action](https://github.com/anothrNick/github-tag-action)

### Projects using github-tag-action

A list of projects using github-tag-action for reference.

* wiktorj/github-tag-action (uses itself to create tags)

* [kaos](https://github.com/KI-labs/kaos)
  open source platform for simplifying machine learning deployment https://www.ki-labs.com/kaos

