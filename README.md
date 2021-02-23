# dotfiles

XDG base directory specification on *NIX


## Setting GitHub with SSH

+ Setup global details and preferences for all repositories

  ```
  git config --global user.name "Saurabh Mishra"
  git config --global user.email "saurab.mish@gmail.com"
  git config --global pull.rebase false
  git config --global core.autocrlf true
  git config --global core.editor "emacs"
  ```

+ Verify global configuration

  `git config --global --list`

+ Generate a new SSH key

  `ssh-keygen -t ed25519 -C "your_email@example.com"`

+ Save the public / private key pair in ~/.config/ssh

  `/Users/saurabh/.config/ssh/id_ed25519`

+ Enter passphrase for key

+ Start SSH agent in the background

  `eval "$(ssh-agent -s)"`

+ Create a global git configuration file

  `touch $HOME/.config/ssh/config`

+ Add the following contents to automatically load keys into the ssh-agent and store passphrases in the keychain

  ```
  Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.config/ssh/id_ed25519
  ```

+ Add the private SSH key to the ssh-agent and store the passphrase in the keychain (verify key passphrase)

  `ssh-add -K /Users/saurabh/.config/ssh/id_ed25519`

+ Persist passphrase even after restarts

  `ssh-add -A`

+ Copy public key to clipboard

  `pbcopy < $HOME/.config/ssh/id_ed25519.pub`

+ Login to github.com and navigate to:

  > Avatar > Settings > SSH and GPG keys > New SSH key (or Add SSH key) > Add title > Paste key
  > Enter GitHub password to confirm

+ Test connection to github.com (this creates a `known_hosts` file in `$HOME/.ssh/`)

  `ssh -T git@github.com`

+ Copy the `known_hosts` file to `$HOME/.config/ssh/`

  `mv $HOME/.ssh/known_hosts $HOME/.config/ssh/`

+ Change ssh directory and file permissions

  ```
  sudo chmod 700 ~/.config/ssh/
  sudo chmod 600 ~/.config/ssh/*
  ```

+ Add global options for known hosts and private key

  `git config core.sshCommand "ssh -K -o UserKnownHostsFile=/Users/saurabh/.config/ssh/known_hosts -i /Users/saurabh/.config/ssh/id_ed25519 -F /dev/null"`

