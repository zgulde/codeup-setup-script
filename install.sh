#!/bin/bash

# Setup script for codeup student's laptops

# 1. check for xcode, if it does not exist go ahead and install it
# 2. do the same for brew
# 3. if $HOME/.ssh/id_rsa does not exist, generate ssh keys and open github so
#    it can be configured there

wait-to-continue(){
    echo
    echo 'Press Enter to continue or Ctrl-C to exit'
    read
}

install-xcode(){
    echo "We need to install some commandline tools for Xcode. When you press 'Enter',"
    echo "a dialog will pop up with several options. Click the 'Install' button and wait."
    echo "Once the process completes, come back here and we will proceed with the next step."
    wait-to-continue

    xcode-select --install 2>&1

    # wait for xcode...
    while sleep 1; do
        xcode-select --print-path >/dev/null 2>&1 && break
    done
}

install-brew(){
    echo 'We are now going to install homebrew, a package manager for OSX.'
    wait-to-continue
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

setup-ssh-keys(){
    echo "We're now going to generate an SSH public/private key pair. This key is"
    echo "like a fingerprint for you on your laptop. We'll use this key for connecting"
    echo "to GitHub without having to enter a password."

    echo "We will be putting a comment in the SSH key pair as well. Comments can be"
    echo "used to keep track of different keys on different servers. The comment"
    echo "will be formatted as [your name]@codeup."

    while [ -z $NAME ]; do
        read -p 'Enter your name: ' NAME
    done

    ssh-keygen -trsa -b2048 -C "$NAME@codeup" -f $HOME/.ssh/id_rsa -N ''

    pbcopy < $HOME/.ssh/id_rsa.pub

    echo "We've copied your ssh key to the clipboard for you. Now, we are going to take you"
    echo "to the GitHub website where you will add it as one of your keys by clicking the"
    echo "\"Add SSH key\" button and pasting the contents in there."

    open https://github.com/settings/ssh

    wait-to-continue
}

echo 'We are going to check if xcode and brew are installed, and if you have ssh keys setup.'
echo "If you don't see any output, then everything is good to go!"
wait-to-continue

xcode-select --print-path >/dev/null 2>&1 || install-xcode

which brew >/dev/null 2>&1 || install-brew

[ -d $HOME/.ssh ] && [ -f $HOME/.ssh/id_rsa ] || setup-ssh-keys

echo "Ok! We've gotten everything setup and you should be ready to go!"
echo "Good luck in class!"
echo
echo "     _____         _____           _                  _ "
echo "    |  __ \\       /  __ \\         | |                | |"
echo "    | |  \\/ ___   | /  \\/ ___   __| | ___ _   _ _ __ | |"
echo "    | | __ / _ \\  | |    / _ \\ / _  |/ _ \\ | | | '_ \\| |"
echo "    | |_\\ \\ (_) | | \\__/\\ (_) | (_| |  __/ |_| | |_) |_|"
echo "     \\____/\\___/   \\____/\\___/ \\__,_|\\___|\\__,_| .__/(_)"
echo "                                               | |      "
echo "                                               |_|      "
