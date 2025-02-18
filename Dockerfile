FROM alpine:latest

LABEL org.opencontainers.image.authors="Oliver Filla <https://github.com/ofilla>, Carlos Bernárdez <carlos@z4studios.com>"

RUN apk add --no-cache openssh git

# -D flag avoids password generation
# -s flag changes user's shell
RUN adduser -D -s /usr/bin/git-shell git \
    && mkdir -p /git-server/keys /git-server/repos ~git/.ssh

# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user’s home directory.
# More info: https://git-scm.com/docs/git-shell
COPY --chown=git:git git-shell-commands /home/git/git-shell-commands

# sshd_config file is edited for enable access key and disable access password
COPY sshd_config /etc/ssh/sshd_config
COPY start.sh start.sh

EXPOSE 22

CMD ["sh", "start.sh"]
