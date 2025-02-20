#!/bin/sh

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

# generate host keys, if required
ssh-keygen -A -f /opt

# If there are some public keys in keys folder
# then it copies its contain in authorized_keys file
if [ "$(ls -A /git-server/keys/)" ]; then
  cd /home/git
  cat /git-server/keys/*.pub > /home/git/.ssh/authorized_keys
  chown -R git:git /home/git/.ssh
  chmod 700 /home/git/.ssh
  chmod -R 600 /home/git/.ssh/*
fi

# Checking permissions and fixing SGID bit in repos folder
# More info: https://github.com/jkarlosb/git-server-docker/issues/1
if [ "$(ls -A /git-server/repos/)" ]; then
  chown -R git:git /git-server/repos
  chmod -R ug+rwX /git-server/repos
  find /git-server/repos -type d -exec chmod g+s '{}' +
fi

# -D: do not detach
# -e: debug logs to standard error
/usr/sbin/sshd -D -e &

child=$!
wait "$child"
