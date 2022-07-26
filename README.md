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