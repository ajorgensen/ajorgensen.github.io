+++
title = "Install homebrew to your home directory"
date = "2017-04-22T13:38:10-04:00"
tags = ["homebrew"]

+++

Installing homebrew to your home directory allows for better control over where packages are installed and avoid running into System Integrity Protection which was added to El Capitan. Also its extremely easy to do.
<!--more-->

## Fresh install
If you already have homebrew installed you can run `brew list | tr '\r\n' ' '` to get a list of packages that were installed with homebrew. Save this list, we will use it later. At this point you can also uninstall homebrew so it does not conflict with the new installation.

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
```

Installing homebrew to a custom directory is pretty straightforward.
```bash
cd $HOME
git clone https://github.com/mxcl/homebrew.git
```

Next we need to make sure the homebrew bin directory is in your `$PATH` in order to use installed packages.

```bash
export PATH=$HOME/homebrew/bin:$PATH
```

It's important to note here that we are putting the `homebrew/bin` directory at the front of the path. This allows us to install packages that are also provided by OSX but because the homebrew directory comes first it will us our installed version rather than the default os version.

At this point you can install all of the packages that were previously installed. This step might take a little while.
```bash
brew install vim tree tmux ...
```

You're done! Reload your terminal and verify that running `which brew` shows homebrew is installed in its new location.

## Bonus tip
I've create an alias that updates homebrew, upgrades any installed formulas, and then cleans up any files that are no longer necessary. This can be useful for keeping your system up to date. Running `brew cleanup` from time to time is also important as I've seen it clean upwards of __1GB__ of space.

```bash
alias sysup='brew update && brew upgrade; brew cleanup'
```
