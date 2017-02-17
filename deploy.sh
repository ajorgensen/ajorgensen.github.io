#!/bin/bash

if test ! $(which hugo); then
  echo "You need to have hugo installed"
  exit 1
fi

if test ! $(which firebase); then
  echo "You need to have firebase installed"
  exit 1
fi

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Deploy to firebase
firebase deploy
