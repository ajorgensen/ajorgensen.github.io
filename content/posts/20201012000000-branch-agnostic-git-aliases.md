---
title: "Branch Agnostic Git Aliases"
pubDate: 2020-10-12
tags:
  - git
postSlug: branch-agnostic-git-aliases
---

Github and others have recently changed the name of the default branch in git
from `master` to `main`, you can read more about the change [here][1]. If you
are like me you likely had a few git aliases that were hard coded to assume the
default branch in a repository was `master`, however there is a better way of
writing git aliases that will work no matter what the default is set to.

<!--more-->

Git aliases allow you to create custom shortcuts to make your git workflow
easier and more intuitive, you can find a full list of the git aliases I use
[here][2]. To outline the problem lets looks at a few example aliases that someone
might have.

```yaml
[alias]
  diff = diff master
  pom = push origin master
  merged-branches = "!git branch --merged master"
  sync = "!git fetch -p && git rebase origin/master"
```

With the change to the default branch being up to the repository maintainer you
may be in a scenario where some repositories you work with will have different
default branch names. One solution to this is to duplicate any aliases you want
to work with each of the defaults but that can get tedious and error prone, what
if someone chooses to go old school and use `trunk` instead?

Fortunately there is a way to write your git aliases in a branch agnostic way
using `git symbolic-ref`. First the __tl;dr__

```yaml
[alias]
  default-branch = "!git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/"
  diff = diff $(git default-branch)
  pom = push origin $(git default-branch)
  merged-branches = "!git branch --merged $(git default-branch)"
  sync = "!git fetch -p && git rebase origin/$(git default-branch)"
```

# How does it work?
If you want to rename the branch for your own repositories you can find steps
[here][3].

In git there is a reference stored at the `.git/HEAD` that tells git what the
default branch is. There is a similar reference on the remote side as well. One
thing to note is that actually charging the default branch on the remote side,
each client should also sync their local state as well to match using `git
remote set-head origin --auto`.

Once this value is synchronized, it should be updated locally as well and we can
use `git symbolic-ref` to get the branch that `HEAD`. Fortunately this gives as
a way to create git aliases and scripts that are agnostic to what the remote has
set the default branch to be.

[1]: https://www.zdnet.com/article/github-to-replace-master-with-main-starting-next-month/
[2]: https://github.com/ajorgensen/dotfiles/blob/master/.gitconfig#L40
[3]: https://jarv.is/notes/github-rename-master/
