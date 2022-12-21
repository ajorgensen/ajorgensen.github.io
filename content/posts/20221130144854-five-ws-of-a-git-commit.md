---
title: "The Five Ws of a Git Commit"
slug: five-ws-of-git-commit
date: 2022-12-21T0:00:00-05:00
draft: false
tags:
    - git
---

Your commit history is not for you, at least not for you of right now. You of right now are full of context and understanding that despite how much we may convince ourselves that we'll remember with perfect clarity tomorrow, I rarely find that to be the case. To solve this problem it's important to approach our commit history like a story.

As a brief aside, commit history has turned into a bit of a cult following. Whether you are a linearity purist or love to fall asleep with your head resting soundly on your merge bubbles, I believe these are both missing the more critical point. There are certainly pros and cons to both that I won't go into here but they miss the most important aspect of your git history, context.

Similar to a good story, every commit must outline the **Who**, **What**, **Where**, **When**, and most importantly **Why**. These 5 aspects allow the audience to properly orient themselves in the story and to understand the context in which the commit was made. Even if we're just missing one of these aspects, the commit cannot adequately fulfill its purpose.

As developers, we lean on our tools quite a bit to handle those annoying aspects of our workflow; version control is no exception here. Let's take a look at how our version control helps us tell our story.

Fortunately, git does a pretty good job of tracking the **Who** and **When** for us. We have to look no further than `git log` to see know who was involved in a set of commits. We can see that yours truly is the author of this commit as well as when it was made. This can be very helpful if we need to ask the committer a question about the code.
```shell
$ git log -n 1
commit b3a996e26eb6718885829915247056cf62ea64e3 (HEAD -> main, origin/main, origin/HEAD)
Author: Andrew Jorgensen <andrew@andrewjorgensen.com>
Date:   Wed Nov 30 14:59:53 2022 -0500

    Start draft post about the 5ws of git commits
```

The **What** and **Where** are also handled by git. 
```diff
$ git show b3a996e26eb6718885829915247056cf62ea64e3
...
+---
+title: "Five Ws for a git commit"
+slug:
+date: 2022-11-30T14:48:54-05:00
...
```

With 4 out of the 5 W's we must be in pretty good shape... but we are missing the most important part, the **Why**. Often relegated to Jira tickets or Trello board the **Why** is one of the most critical pieces of information here. Your commit message should contain all of the information for someone to understand why a change is being made since it's the only piece of information that only you as the committer know. 

While a link to the ticket in the project management software du jour is helpful, I don't believe it is sufficient. Ensuring your commit message tells a coherent and complete story of the change being introduced will help whoever looks at the change in the future will be able to understand not only what has changed but more critically the context of the change.