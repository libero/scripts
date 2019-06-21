#!/bin/bash
set -e


if [ "$#" -ne 0 ]; then
    echo "Add Travis CI to a git-crypt set up for a repository"
	echo "Will create an uncommitted diff."
    echo "Usage: $0"
	exit 1
fi

email="travis-ci@example.com"

if ! which travis; then
	echo "Please install the \`travis\` cli"
	exit 2
fi

if ! which gpg; then
	echo "Please install \`gpg\`"
	exit 3
fi

if ! which git-crypt; then
	echo "Please install the \`git-crypt\` binary"
	exit 4
fi

export GNUPGHOME="$(mktemp -d)"
cat >foo <<EOF
     %echo Generating a basic OpenPGP key
     Key-Type: RSA
     Key-Length: 2048
     Subkey-Length: 2048
     Name-Real: Travis CI
     Name-Email: ${email}
     Expire-Date: 0
     %commit
     %echo done
EOF
gpg --batch --gen-key foo

#gpg --armor --export "${email}" > "travis-ci.pub"
gpg --armor --export-secret-keys "${email}" > travis-ci.key
git crypt add-gpg-user "${email}" --no-commit

travis encrypt-file --com travis-ci.key
rm travis-ci.key
