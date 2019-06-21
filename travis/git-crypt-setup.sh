#!/bin/bash
set -e

email="travis-ci-1234@example.com"

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

#gpg --armor --export "${email}" > "${email}.pub"
gpg --armor --export-secret-keys "${email}" > "${email}.key"
git-crypt add-gpg-user "${email} --no-commit

# TODO: check presence of tools at the start
travis encrypt-file --com "${email}.key"
rm ${email}.key
