#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Unlocks git-crypt encrypted files"
    echo 
    echo "Usage: $0 ENCRYPTED_KEY_FILE"
    echo "Example: $0 travis-ci.key.enc"
    echo
    echo "ENCRYPTED_KEY_FILE is a file containing a git-crypt key, that has been encrypted using Travis CI's encrypt command:"
    echo "https://docs.travis-ci.com/user/encryption-keys/"
    echo
    echo "Relies on the following environment variables:"
    echo "- TRAVIS_KEY, TRAVIS_IV"
    exit 1
fi

git_crypt_key="$1"
git_crypt_version=0.6.0
git_crypt_sha=128817a63de17a5af03fe69241e453436c6c286c86dd37fb70ed9b3bf7171d7d

openssl aes-256-cbc -K "$TRAVIS_KEY" -iv "$TRAVIS_IV" -in "$git_crypt_key" -out /tmp/git-crypt.key -d
gpg --import git-crypt.key
curl -L "https://github.com/minrk/git-crypt-bin/releases/download/${git_crypt_version}/git-crypt" > git-crypt
echo "$git_crypt_sha  git-crypt" | shasum -a 256 -c -
chmod +x git-crypt
sudo mv git-crypt /usr/local/bin/
git crypt unlock
rm /tmp/git-crypt.key
