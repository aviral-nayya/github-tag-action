# GitHub Tag Action

A Github Action to automatically bump and tag the branch passed by env variable and update `latest` tag to point to the latest commit based on the default bump.

### Usage

```Dockerfile
name: bump and tag branch
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
      uses: kimgault/github-tag-action@v1.0
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        BRANCH: master
        DEFAULT_BUMP: minor
```

> ***Note:*** This workflow should be on a push or merge.

#### Options

**Environment Variables**

* **GITHUB_TOKEN** ***(required)*** - Required for permission to tag the repo.
* **BRANCH** ***(required)*** - Branch name.
* **DEFAULT_BUMP** ***(required)*** - Branch name.
* **WITH_V** *(optional)* - Tag version with `v` character. Defaults to true.

#### Outputs

* **new_tag** - The value of the newly created tag.

> ***Note:*** This action creates a [annotated tag](https://git-scm.com/book/en/v1/Git-Internals-Git-References#Tags).

### Semantic Versioning

Versioning will follow [https://semver.org/](https://semver.org/):

Given a version number MAJOR.MINOR.PATCH, increment the:

MAJOR version when you make incompatible API changes,
MINOR version when you add functionality in a backwards compatible manner, and
PATCH version when you make backwards compatible bug fixes.
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

### Bumping

With every commit to master `latest` tag is updated to the latest commit in the master branch. 

Any commit message that includes `#major`, `#minor`, or `#patch` will trigger the respective version bump. If two or more are present, the highest-ranking one will take precedence.

> ***Note:*** This action **will not** bump the tag if the `HEAD` commit has already been tagged.

### Workflow

* Add this action to your repo
* Commit some changes
* Decide what branch you want to compare, example is master.
* Either push to master or open a PR
* On push (or merge) to `master`, the action will:
  * Get latest tag (different than `latest`)
  * Bump the tag **if** commit message contains one of the: `#major`, `#minor` or `#patch` 
  * Updates `latest` tag to point to the latest commit on the master branch
  * Pushes tags updates to github

### Credits

Forked from:
[WiktorJ/github-tag-action](https://github.com/WiktorJ/github-tag-action)


