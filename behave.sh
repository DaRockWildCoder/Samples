#!/usr/bin/env bash

set -e

basedir=$(dirname $0)
reinit_flag=$basedir/reinit
PATH+=:~/.local/bin

command_available() {
  local cmd=$1
  command -v $cmd >/dev/null
}

env_exists() {
  pipenv --venv >/dev/null 2>&1
}

# ensure pipenv available
if ! command_available pipenv >/dev/null; then
  echo "installing 'pipenv'"
  pip3 install --user pipenv
fi

# set working dir
cd $basedir


# initialize framework if requested/needed
if [ -f $reinit_flag ] ; then
  pipenv --rm || true
  rm $reinit_flag
fi
if ! env_exists; then
  pipenv --three sync
fi

# run samples
touch test.log
echo exec pipenv run behave $*
