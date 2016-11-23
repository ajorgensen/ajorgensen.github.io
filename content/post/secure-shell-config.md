+++
date = "2016-11-21T22:30:10-05:00"
title = "How to not leak your credentials to the internet"
tags = ["security", "bash", "zsh"] 

aliases = ["/content/post/secure-shell-config"]

+++
Sharing your dotfiles on the internet can have a lot of advantages but can become a huge pain if you're not careful.
<!--more-->

Uploading your dotfiles allows you to easily bootstrap a new machine with all of those precious settings that you painstakingly configured over the course of your career. It serves as a backup in case your machine decides its time to go to the great Apple store in the sky. Also its just awesome to look around at other peoples configs and learn new tricks that you might now have discovered on your own. The problem comes when you need to add some private credentials to your configuration without checking them in for the world to see.

One good security practice is to not store any unencrypted credentials at rest. If you can run `cat` on a file and see the credentials appear on the screen this means that are unencrypted at rest and just waiting for an attacker to read that file and pull the credentials out for nefarious purposes. Typically credentials in your profile would look something like...

```
export AWS_ACCESS_KEY_ID "AKIATHISISMYKEY"
export AWS_ACCESS_KEY_SECRET "thisismyreallysecretkeythatnooneshouldknow"
```

If that looks anything like your `~/.zshrc` or `~/.bash_profile` then you probably want to keep reading. One clever way to work around the need to hard code the keys into environment variables is to use the keychain built into OSX to store any credentials. To make this easier we can add the following functions to store and retrieve keys and secrets.

```
### Functions for setting and getting environment variables from the OSX keychain ###
### Adapted from https://www.netmeister.org/blog/keychain-passwords.html ###

# Use: keychain-environment-variable SECRET_ENV_VAR
function keychain-environment-variable () {
    security find-generic-password -w -a ${USER} -D "environment variable" -s "${1}"
}

# Use: set-keychain-environment-variable SECRET_ENV_VAR super_secret_key_abc123
function set-keychain-environment-variable () {
    [ -n "$1" ] || print "Missing environment variable name"
    
    # Note: if using bash, use `-p` to indicate a prompt string, rather than the leading `?`
    read -s "?Enter Value for ${1}: " secret
    
    ( [ -n "$1" ] && [ -n "$secret" ] ) || return 1
    security add-generic-password -U -a ${USER} -D "environment variable" -s "${1}" -w "${secret}"
}
```

Now you can easily and securely store keys and secrets using the `set-keychain-environment-variable` function! Instead of hard coding the credentials we can simply replace all the hard coded values with:


```
export AWS_ACCESS_KEY_ID $(keychain-environment-variable AWS_ACCESS_KEY_ID)
export AWS_ACCESS_KEY_SECRET $(keychain-environment-variable AWS_ACCESS_KEY_SECRET)
```

OSX will prompt you the first time for the password to unlock the keychain but once you have it unlocked it will remember and wont prompt you again. Now you don't have to be worried about accidentally checking your private keys into your git repository and publishing them to the internet for all to see. Be sure to clear out your `~/.zsh_history` or `~/.bash_history` files after you've run the commands to make sure the credentials were not recorded there. 

Happy encrypting!
