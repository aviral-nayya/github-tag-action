#!/bin/bash

# config
default_semvar_bump=${DEFAULT_BUMP:-none}
with_v=${WITH_V:-false}
# get latest tag
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
tag_commit=$(git rev-list -n 1 $tag)
# get current commit hash for tag
commit=$(git rev-parse HEAD)
git_refs_url=$(jq .repository.git_refs_url $GITHUB_EVENT_PATH | tr -d '"' | sed 's/{\/sha}//g')
if [ "$tag_commit" == "$commit" ]; then
    echo "No new commits since previous tag. Skipping..."
    exit 0
fi
if [ "$tag" == "latest" ]; then
    tag=$(git describe --tags `git rev-list --tags --max-count=2` | tail -n 1)
fi
# if there are none, start tags at 0.0.0
if [ -z "$tag" ]
then
    log=$(git log --pretty=oneline)
    tag=0.0.0
else
    log=$(git log $tag..HEAD --pretty=oneline)
fi

# get commit logs and determine home to bump the version
# supports #major, #minor, #patch (anything else will be 'minor')
case "$log" in
    *#major* ) new=$(semver bump major $tag);;
    *#minor* ) new=$(semver bump minor $tag);;
    * ) new="none";;
esac

if [ "$new" != "none" ]; then
	# prefix with 'v'
	if $with_v
	then
	    new="v$new"
	fi
	echo $new

	# set output
	echo ::set-output name=new_tag::$new

	# push new tag ref to github
	dt=$(date '+%Y-%m-%dT%H:%M:%SZ')
	full_name=$GITHUB_REPOSITORY

	echo "$dt: **pushing tag $new to repo $full_name"
	echo "refs: $git_refs_url"
		
	curl -s -X POST $git_refs_url \
	-H "Authorization: token $GITHUB_TOKEN" \
	-d '{"ref": "refs/tags/'$new'", "sha": "'$commit'"}'
fi	

curl -s -X DELETE "$git_refs_url/tags/latest" \
 -H "Authorization: token $GITHUB_TOKEN" \

curl -s -X POST $git_refs_url \
 -H "Authorization: token $GITHUB_TOKEN" \
 -d '{"ref": "refs/tags/latest", "sha": "'$commit'"}'
