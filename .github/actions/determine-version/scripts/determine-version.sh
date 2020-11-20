#!/usr/bin/env bash

BASE_VERSION="${INPUTS_BASE_VERSION}"
MAJOR_VERSION=$( echo "$BASE_VERSION" | sed -E 's/([0-9]+)\..*/\1/' )
MINOR_VERSION=$( echo "$BASE_VERSION" | sed -E 's/[0-9]+\.([0-9]+)\..*/\1/' )
PATCH_VERSION=$( echo "$BASE_VERSION" | sed -E 's/[0-9]+\.[0-9]+\.([0-9]+).*/\1/' )
PRE_RELEASE=$( echo "$BASE_VERSION" | sed -E 's/[0-9.]+(-[^+]+)?.*/\1/' )
META=$( echo "$BASE_VERSION" | sed -E 's/[0-9.]+(-[^+]+)?(\+.*)?/\2/' )

PATCH_VERSION=$GITHUB_RUN_ID
if [ "$GITHUB_REF" = "refs/heads/master" ]
then
    PRE_RELEASE="${PRE_RELEASE:--}${PRE_RELEASE:+.}dev"
elif [[ "$GITHUB_REF" =~ ^refs/heads/.*$ ]]
then
    BRANCH_SLUG=$( echo "$GITHUB_REF" | sed -E 's/^refs\/heads\/(.*)/\1/' | sed -E 's/[^a-zA-Z0-9_-]/-/g' )
    PRE_RELEASE="${PRE_RELEASE:--}${PRE_RELEASE:+.}blood.branch.${BRANCH_SLUG}"
else
    REF_TYPE=$( echo "$GITHUB_REF" | sed -E 's/^refs\/(^[\/]*)\/.*/\1/' )
    SLUG=$( echo "$GITHUB_REF" | sed -E 's/^refs\/^[\/]*\/(.*)/\1/' | sed -E 's/[^a-zA-Z0-9_-]/-/g' )
    PRE_RELEASE="${PRE_RELEASE:--}${PRE_RELEASE:+.}blood.${REF_TYPE}.${SLUG}"
fi
echo "::set-output name=version::$MAJOR_VERSION.$MINOR_VERSION.$PATCH_VERSION$PRE_RELEASE$META"