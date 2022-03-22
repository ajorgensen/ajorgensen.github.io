---
date: 2019-05-28
title: "Signing Git Commits With Keybase"
tags:
    - git
    - security
    - keybase
slug: signing-git-commits-with-keybase
---

Signing your commits is a good practice that applies your John Hancock to your work so that others can verify that it was really you made the change, plus you get a cool Verified badge on GitHub and who doesn't like badges. Managing private keys can be a tricky process but fortunately [keybase](https://keybase.io/) greatly simplifies this and allows us to easily share keys between different machines.

<!--more-->

# Install Keybase
If you are a homebrew fan then installing keybase is as easy as `brew cask install keybase`. If you're more of an 'old fashioned' kind of person, head on over to [keybase.io/download](https://keybase.io/download).

# Export your gpg key
First you will need to make sure that gpg is installed correctly on your machine. Installing gpg is pretty simple with homebrew, `brew install gnupg`.

Now that we have that out of the way its time to export our signing key from Keybase so its available to use with gpg. `keybase pgp export | gpg --import` should do the trick. Note that this does assume you only have 1 key stored in keybase, if you have multiple you will need to re-run the same command with `-q <keyID>` to select the appropriate key.

Now we need to export the pgp keys secret into gpg so it can be used for signing. `keybase pgp export --secret | gpg --import --allow-secret-key-import`. Similar to the previous command, if you have multiple keys in keybase you will need to use `-q <keyID>` to specify which secret you want to export.

You should now be able to run `gpg --list-keys` to verify that your key has properly been imported into gpg. You can also run `gpg --list-secret-keys` to verify your secret has been successfully imported.

# Setup git to sign our commits
Now we need to teach git how to use our key to sign our commits. This is fairly straightforward, the first thing we need to do is to turn on commit signing `git config --global commit.gpgsign true`. This will modify your `~/.gitconfig` to enable gpg signing automatically on commit.

You may also need to tell what signing key git should use. If you already know the signature, great! If not you can list your installed keys with `gpg --list-keys --keyid-format LONG` and find the signature that corresponds to your email address for the key you just imported. Now we can tell git which key to use for signing `git config --global user.signingKey B104211111`. While you're at it, make sure your email is set correctly `git config --global user.email user@mail.com`.

# Tell GitHub to give us that sweet Verified badge
Next we need to tell GitHub about our signing key so it can properly verify our signed commits. You can export the public signature using `gpg --armor --export keyID`. Copy this value and head on over to [GitHub](https://github.com/settings/keys) and click on "New GPG key" to add it to your list of key signatures.

Now all commits you make should be correctly signed with your private key and you'll get that Verified badge to let people know you are legit.
