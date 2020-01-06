#!/usr/bin/env bash
# bootstrap script
# install fish, invoke fish bootstrap script, and `exec` fish

# bash best practices
set -o errexit # exit on error
set -o nounset # exit on reference to undefined variable
set -o pipefail # fail on the first non-zero exit code in a pipeline

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "bootstrap: fatal: operating system is not darwin"
    exit 1
fi

# Make sure homebrew is installed
which brew &> /dev/null
if [[ $? != 0 ]]; then
    echo "boostrap: installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# print homebrew version
echo "bootstrap: homebrew is installed"
brew --version

# Install fish
echo "bootstrap: installing fish"
brew install fish

# Change shell to fish
chsh -s "$(which fish)" "$(whoami)"

# Record the original working directory
ORIGINAL_PWD="$(pwd)"

# Go to dotfiles repo
cd $(realpath $0 | sed -e 's/bootstrap\.sh$//')

# Run fish bootstrap script
fish ./bootstrap.fish

echo "bootstrap: done"

cd "$ORIGINAL_PWD"

# Replace bash with fish
exec "$(which fish)"

