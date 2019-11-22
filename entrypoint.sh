#!/bin/bash

# config
default_semvar_bump=${BUMP:-minor}
with_v=${WITH_V:-true}

# get latest tag
git checkout $BRANCH
git pull
tag=$(git tag --sort=-creatordate | head -n 1)
echo "tag before latest check: $tag"
tag_commit=$(git rev-list -n 1 $tag)

# get current commit hash for tag
commit=$(git rev-parse HEAD)
git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')

if [ "$tag_commit" == "$commit" ]; then
    echo "No new commits since previous tag. Skipping..."
    exit 0
fi

if [ "$tag" == "latest" ]; then
    tag=$(git tag --sort=-creatordate | head -n 2 | tail -n 1)
fi

echo "tag before update: $tag"
# if there are none or it's still latest or v, start tags at 0.0.0
if [ -z "$tag" ] || [ "$tag" == "latest" ] || [ "$tag" == "v" ]; then
    echo "Tag does not mmatch semver scheme X.Y.Z(-PRERELEASE)(+BUILD). Changing to 0.0.0'"
    tag="0.0.0"
fi

new=$(semver bump $default_semvar_bump $tag);

git config user.email "actions@github.com" 
git config user.name "GitHub Merge Action"

if [ "$new" != "none" ]; then
    # prefix with 'v'
    if $with_v; then
        new="v$new"
    fi
    echo "new tag: $new"

    # push new tag ref to github
    dt=$(date '+%Y-%m-%dT%H:%M:%SZ')
    full_name=$GITHUB_REPOSITORY

    echo "$dt: **pushing tag $new to repo $full_name"

    curl -s -X POST $git_refs_url \
    -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"ref": "refs/tags/'$new'", "sha": "'$commit'"}'
fi	

echo "git push origin :refs/tags/latest"
git push origin :refs/tags/latest
echo "git tag -fa -m "latest release" latest $commit"
git tag -fa -m "latest release" latest $commit
echo "git push --follow-tag"
git push --follow-tag
