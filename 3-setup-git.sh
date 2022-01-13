#!/bin/bash

set -xe

mkdir -p $HOME/.ssh
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

# global
git config --global user.name "rajesh"
git config --global user.email "rajesh.nitc@gmail.com"

# local
# git config user.name "rajesh"
# git config user.email ""

# Custom
# export GIT_SSH_COMMAND="ssh -i ~/.ssh/github"