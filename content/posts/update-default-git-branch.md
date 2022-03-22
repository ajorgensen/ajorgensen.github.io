+++
title = "Change Default git Branch"
date = 2022-03-21T21:45:01-04:00
tags = ["git"]
+++

First we'll need to rename the old branch to the new branch. For this we'll be renaming the master branch to main.

<!--more-->

```bash
git branch -m master main
```

Since the rename was only a local change, we now need to push up the new renamed branch to remote.

```bash
git push -u origin main
```

Next we need to tell git that main is the new default branch by updating the reference to HEAD

```bash
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
```

Next if you're pushing to Github you'll want to go into the branches settings for the repository and update the default branch from the old branch to the new branch (main in this case)

At this point you can verify that the correct branch is set as the default in Github as well as check locally to make sure everything is setup correctly by doing

```bash
git branch -a
```

Once  you've verified everything is correct you can now safely delete the old branch from Github

```bash
git push origin --delete master
```