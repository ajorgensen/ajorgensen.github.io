---
title: "Use CDPATH for Faster Navigation"
slug: use-cdpath-for-faster-navigation
date: 2022-03-21T23:30:43-04:00
tags:
    - shell
draft: false
---

CDPATH is an environment variable that allows you to cd into directors that may not be in your current working directory. It can be useful to add commonly used directions, ~/code for example, to allow you to quickly change directory without having to type out the full path.

<!-- more -->

Normally, cd will check the current directory for the folder name that is passed to it. However it can be useful to tell cd to also check other directories for a specific folder name. To set the order in which cd will check for the specified folder name is as easy as exporting the environment variable CDPATH in the order you'd like it to check in. For example:

```bash
export CDPATH=".:$HOME:$HOME/code"
```

This will tell cd to first check for the folder name in the current directory and then check in $HOME and finally in $HOME/code. This is especially useful if you have a directory where most of your projects are stored and you want to quickly switch between them without typing the whole path.
