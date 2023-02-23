#!/bin/bash

# https://github.com/olivergondza/bash-strict-mode
set -eEuo pipefail
trap 's=$?; echo >&2 "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

if [ $# -lt 2 ]; then
    echo >&2 "Usage: $0 <COMMAND> <IMAGE_NAME>"
    echo >&2
    exit 1
fi

function docker_rm(){
    images_to_rm=($1)
    for image_to_rm in ${images_to_rm[@]}; do
        container_list=$(podman ps -a -q --filter "ancestor=$image_to_rm")
        if [[ ! -z "$container_list" ]]; then
            container_list_space="${container_list//$'\n'/ }"
            podman rm $(podman stop $container_list_space)
        else
            echo "No containers found with ancestor=$image_to_rm"
        fi
    done
}

function docker_rmi(){
    images_to_rmi=($1)
    for image_to_rmi in ${images_to_rmi[@]}; do
        image_list=$(podman images -q --filter "reference=$image_to_rmi")
        if [[ ! -z "$image_list" ]]; then
            image_list_space="${image_list//$'\n'/ }"
            podman rmi $image_list_space
        else
            echo "No images found with reference=$image_to_rmi"
        fi
    done
}

COMMAND="$1"
IMAGE_NAME_LIST="${@:2}" # using all arguments except for the first 1 (rm / rmi)

if [[ "$COMMAND" == "rm" ]]; then
    docker_rm "$IMAGE_NAME_LIST"
fi

if [[ "$COMMAND" == "rmi" ]]; then
    docker_rmi "$IMAGE_NAME_LIST"
fi
