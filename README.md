# git-server-docker
A lightweight Git Server Docker image built with Alpine Linux. Available on [GitHub](https://github.com/ofilla/git-server-docker) and [GitHub Container Registry](https://github.com/ofilla/git-server-docker/pkgs/container/git-server-docker).

!["image git server docker" "git server docker"](https://raw.githubusercontent.com/ofilla/git-server-docker/master/git-server-docker.jpg)

This image is built daily, based on `alpine:latest`.

### Basic Usage

How to run the container in port 2222 with two volumes: keys volume for public keys and repos volume for git repositories:

```
$ docker run -d \
    -p 2222:22 \
    -v ~/git-server/keys:/git-server/keys \
    -v ~/git-server/repos:/git-server/repos \
    ghcr.io/ofilla/git-server-docker
```

How to use a public key:

* Copy them to keys folder:
  * From host: `$ cp ~/.ssh/id_rsa.pub ~/git-server/keys`
  * From remote: `$ scp ~/.ssh/id_rsa.pub user@host:~/git-server/keys`
* You need restart the container when keys are updated: `$ docker restart <container-id>`

How to check that container works (you must to have a key):

```
$ ssh git@<ip-docker-server> -p 2222
...
Welcome to git-server-docker!
You've successfully authenticated, but I do not
provide interactive shell access.
...
```

How to create a new repo:

```
$ cd myrepo
$ git init --shared=true
$ git add .
$ git commit -m "my first commit"
$ cd ..
$ git clone --bare myrepo myrepo.git
```

How to upload a repo:

* From host: `$ mv myrepo.git ~/git-server/repos`
* From remote: `$ scp -r myrepo.git user@host:~/git-server/repos`

How clone a repository:

```
$ git clone ssh://git@<ip-docker-server>:2222/git-server/repos/myrepo.git
```

### Arguments

* **Expose ports**: 22
* **Volumes**:
  * `/git-server/keys`: Volume to store the users public keys
  * `/git-server/repos`: Volume to store the repositories
  * `/git-server/host-keys`: Volume to store the SSHd host keys

### SSH Keys

How generate a pair keys in client machine:

```
$ ssh-keygen -t rsa
```

How upload quickly a public key to host volume:

```
$ scp ~/.ssh/id_rsa.pub user@host:~/git-server/keys
```


### Build Image

How to make the image:

```
$ docker build -t git-server-docker .
```


### Docker-Compose

You can edit `docker-compose.yml` and run this container with docker-compose:

```
$ docker-compose up -d
```

Environment Variables:

* `GIT_SERVER_KEYS_DIR`: Path to public keys to accept, on the host
* `GIT_SERVER_REPO_DIR`: Path to repositories, on the host
