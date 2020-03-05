#!/bin/bash
set -e
set -x

if [[ "$CIRRUS_CI" = false || -z $CIRRUS_CI ]]
then
  echo "This script is aimed to be run on CI environments. Do not run locally."
  exit 1
fi

if [[ -z $ENGINE_PATH ]]
then
  echo "Engine path should be set to run the script."
  exit 1
fi

# Go to the engine git repo to get the date of the latest commit.
cd $ENGINE_PATH/src/flutter

# Special handling of release branches.
ENGINE_BRANCH_NAME=`git branch | grep '*' | cut -d ' ' -f2`
versionregex="^v[[:digit:]]+\."
ON_RELEASE_BRANCH=false
echo "Engine on branch $ENGINE_BRANCH_NAME"
if [[ $ENGINE_BRANCH_NAME =~ $versionregex ]]
then
  echo "release branch $ENGINE_BRANCH_NAME"
  ON_RELEASE_BRANCH=true
fi

# Get latest commit's time for the engine repo.
# Use date based on local time otherwise timezones might get mixed.
LATEST_COMMIT_TIME_ENGINE=`git log -1 --date=local --format="%ad"`
echo "Latest commit time on engine found as $LATEST_COMMIT_TIME_ENGINE"

# Do rest of the task in the root directory
cd ~
mkdir -p $FRAMEWORK_PATH
cd $FRAMEWORK_PATH
# Clone the Flutter Framework.
git clone https://github.com/flutter/flutter.git
cd flutter

FRAMEWORK_BRANCH_NAME=`git branch | grep '*' | cut -d ' ' -f2`
if [[ "$ON_RELEASE_BRANCH" = true && ENGINE_BRANCH_NAME != FRAMEWORK_BRANCH_NAME ]]
then
  echo "For a release framework and engine should be on the same version."
  echo "Switching branches on Framework to from $FRAMEWORK_BRANCH_NAME to $ENGINE_BRANCH_NAME"
  # Switch to the same version branch with the engine.
  # If same version branch does not exits, fail.
  SWITCH_RESULT=`git checkout $ENGINE_BRANCH_NAME` || true
  if [[ -z "$SWITCH_RESULT" ]]
  then
    echo "$ENGINE_BRANCH_NAME Branch not found on framework. Quit."
    exit 1
  fi
fi

# Get the time of the youngest commit older than engine commit.
# Git log uses commit date not the author date.
# Before makes the comparison considering the timezone as well.
COMMIT_NO=`git log --before="$LATEST_COMMIT_TIME_ENGINE" -n 1 | grep commit | cut -d ' ' -f2`
echo "Using the flutter/flutter commit $COMMIT_NO";
git reset --hard $COMMIT_NO