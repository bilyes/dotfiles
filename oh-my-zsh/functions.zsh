function drmi() {
    # TODO Check if docker is installed. If not print an error msg
   
    if [[ -z "$1" ]]; then
        echo "Please provide a string to use when matching image names. Usage: drmi my-img"
        exit 1;
    fi

    docker rmi -f $(docker images --format "{{ .ID  }}" --filter "reference=$1*")
}

function dclean() {
    docker rmi -f $(docker images -q -f "dangling=true")
}

function ddestroy() {
    docker rmi $(docker images -q | xargs)
}
