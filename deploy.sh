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
echo -e "\033[0;32mBuilding site...\033[0m"
hugo

git diff-index --quiet HEAD --
if [ $? -ne 0 ]; then
  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ];then
    msg="$1"
  fi

  echo -e "\033[0;32mCommitting changes with message $msg...\033[0m"
  # Add changes to git.
  git add -A

  git commit -m "$msg"

  # Push source and build repos.
  git push origin main
fi

# Deploy to firebase
echo -e "\033[0;32mDeploying to firebase hosting...\033[0m"
firebase deploy
