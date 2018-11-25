# [dclong/jupyterhub-rstudio](https://hub.docker.com/r/dclong/jupyterhub-rstudio/)

JupyterHub and RStudio (with popular R packages) in Docker.
**It is suggested that you use [dclong/jupyterhub-ds](https://hub.docker.com/r/dclong/jupyterhub-ds/)
for data science related work.**


## Detailed Information

OS: the latest Ubuntu 18.04  
Desktop Environment: None  
Remote Desktop: None  
Kernels: 
- Python 3.6.6
- R
Servers: 
- JupyterHub
- RStudio

## Usage in Linux/Unix

### Prerequisites
You must have Docker installed.
If you are on Ubuntu,
the just use the command below to install the community edition of Docker.
```
sudo apt-get install docker.io
```
If you'd rather install the enterprise edition
or if you are on other platforms,
please refer to the offical Docker doc [Install Docker](https://docs.docker.com/install/).

### Pull the Docker Image
```
docker pull dclong/jupyterhub-rstudio
```
For people in mainland of China,
please refer to the post
[Speedup Docker Pulling and Pushing](http://www.legendu.net/en/blog/speedup-docker-pulling-and-pushing/)
on ways to speed up pushing/pulling of Docker images.
If you don't bother,
then just use the command below.
```
docker pull registry.docker-cn.com/dclong/jupyterhub-rstudio
```

### Start a Container

Below are some Docker command arguments explained.
These are for properly handling file permissions in the Docker container and on the host.
Keep the default if you don't know what are the best to use.
`DOCKER_PASSWORD` is probably the only argument you want to and should change.

- `DOCKER_USER`: The user to be created (dynamically) in the container.
    By default, the name of the current user on the host is used.
- `DOCKER_USER_ID`: The ID of the user to be created in the container.
    By default, the ID of the current user on the host is used.
- `DOCKER_PASSWORD`: The password of the user to be created.
    By default, it's the same as the user name.
    You'd better change it for security reasons.
    Of course, users can always change it later using the command `passwd`.
- `DOCKER_GROUP_ID`: The group of the user to be created.
    By default, it's the group ID of the current user on the host.
- `DOCKER_ADMIN_USER`: The admin of the JupyterLab server.
    By default, it's the user to be created in the container.
- `USER_MEM_LIMIT`: The memory limit that each user can use.
    Note that this optional is not in effect now.

The root directory of JupyterLab/Jupyter notebooks is `/workdir` in the container.
You can mount directory on the host to it as you wish.

The following command starts a container 
and mounts the current working directory and the parent directory of `$HOME` 
(`/home` in Linux and `/Users` in Mac) on the host machine 
to `/workdir` and `/home_host` in the container respectively.
```
docker run -d \
    --log-opt max-size=50m \
    -p 8000:8000 \
    -p 8787:8787 \
    -e DOCKER_USER=`id -un` \
    -e DOCKER_USER_ID=`id -u` \
    -e DOCKER_PASSWORD=`id -un` \
    -e DOCKER_GROUP_ID=`id -g` \
    -e DOCKER_ADMIN_USER=`id -un` \
    -v `pwd`:/workdir \
    -v `dirname $HOME`:/home_host \
    dclong/jupyterhub-rstudio
```
The following command (**only works in Linux**) does the same as the above one 
except that it limits the use of CPU and memory.
```
docker run -d \
    --log-opt max-size=50m \
    --memory=$(($(head -n 1 /proc/meminfo | awk '{print $2}') * 4 / 5))k \
    --cpus=$((`nproc` - 1)) \
    -p 8000:8000 \
    -e DOCKER_USER=`id -un` \
    -e DOCKER_USER_ID=`id -u` \
    -e DOCKER_PASSWORD=`id -un` \
    -e DOCKER_GROUP_ID=`id -g` \
    -e DOCKER_ADMIN_USER=`id -un` \
    -v `pwd`:/workdir \
    -v `dirname $HOME`:/home_host \
    dclong/jupyterhub-rstudio
```
## Use the JupyterHub Server

Open your browser and and visit `your_host_ip:8000`
where `your_host_ip` is the URL/ip address of your server.
You will be asked for user name (by default your user name on the host)
and password (by default your user name on the host and might want to change it for security reasons).
You can of course change your user password later
using the command `passwd` in the container.  

## Use the RStudio Server

Open your browser and and visit `your_host_ip:8787`
where `your_host_ip` is the URL/ip address of your server.
You will be asked for user name (by default your user name on the host)
and password (by default your user name on the host and might want to change it for security reasons).
You can of course change your user password later
using the command `passwd` in the container.  

## Add a New User in the Docker Container

By default,
any user in the Docker container can visit the JupyterHub and RStudio server.
So if you want to grant access to a new user,
just create an account for him in the Docker container.
You can of course use the well know commands `useradd`, `adduser`, etc. to achive it.
To make things easier for you,
there are some shell scripts in the directory `/scripts/` to create usres for you.

- `/scripts/create_user.sh`: Create a new user. It's the base script for creating users.
- `/scripts/create_user_group.sh`: Create a new user with the given (existing) group.
- `/scripts/create_user_nogroup.sh`: Create a new user with group name `nogroup`.
- `/scripts/create_user_docker.sh`: Create a new user with group name `docker`.

You can use the option `-h` to print help doc for these commands.
For example, `/scripts/create_user_nogroup.sh -h` prints the below help doc.
```
Create a new user with the group name "nogroup".
Syntax: create_user_nogroup user user_id [password]
Arguments:
user: user name
user_id: user id
password: Optional password of the user. If not provided, then the user name is used as the password.
```
Now suppose you want to create a new user `dclong` with user ID `2000` and group name `nogroup`,
you can use the following command.
```
sudo /scripts/create_user_nogroup.sh dclong 2000
```
Since we didn't specify a password for the user,
the default password (same as the user name) is used.

## Known Issues

1. The subprocess managment issue.
    This is not an issue at in most use cases.
    This Docker image launch service using a shell script
    so there won't be orphan subprocesses
    when the process of the Docker container is get killed.
    However, launching by shell script is not the best way for managing processes.
    I might switch to the [Supervisor](https://github.com/Supervisor/supervisor) for process management
    or use the base image of [pushion/ubuntu](https://github.com/phusion/baseimage-docker) in future.


## About the Author

[Personal Blog](http://www.legendu.net)   |   [GitHub](https://github.com/dclong)   |   [Bitbucket](https://bitbucket.org/dclong/)   |   [LinkedIn](http://www.linkedin.com/in/ben-chuanlong-du-1239b221/)

## [Related Images](http://www.legendu.net/en/blog/my-docker-images/)
