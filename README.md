# Docker / Podman cleanup

## Check disk space used
In RedHat based OS, docker containers will be kept in <code>~/.local/share/containers/storage</code> by default.

<code>
    du -sh ~/.local/share/containers/storage 2> >(grep -v 'Permission denied') | sort -n
</code>

## Containers

### List all containers of specific image

<code>
    docker ps -a -q --filter ancestor=[containerName]
</code>

### List stopped containers of specific image

<code>
    docker ps -a -q --filter "ancestor=[containerName]" --filter "status=exited"
</code>

### Remove stopped containers of specific image

<code>
    docker rm $(docker ps -a -q --filter "ancestor=[containerName]" --filter "status=exited")
</code>

## Images

### List dangling images

<code>
    docker images -q --filter "dangling=true"
</code>

### List images of specific name / tag
- notice this is not an exact match

<code>
    docker images --filter "reference=[imageName]:[imageTag]"
</code>

### Remove images of any group

<code>
    docker rmi $(docker images -q [any filter])
</code>

## System usage

### Docker system info

<code>
    docker system df
</code>

### Docker system prune - remove unused data

<code>
    docker system prune
</code>

### Docker builder cache prune

<code>
    docker builder prune
</code>

## Docker Troubleshooting
### Change image ENTRYPOINT
In case you're getting an error running a container, which might expect environment variable, or run an executalbe, you could debug it by changing the entrypoint:

<code>
    podman run -d --entrypoint "/bin/bash" [image_ID] -c 'while true; do echo sleeping; sleep 2; done'
</code>

If you're getting an error of: <code> Error: unable to find user default: no matching entries in passwd file</code> you'll need to specify the user:

<code>
    podman run -d --user [username/id] --entrypoint "/bin/bash" [image_ID] -c 'while true; do echo sleeping; sleep 2; done'
</code>