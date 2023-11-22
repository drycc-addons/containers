BASE_DIR=$(pwd)
DRYCC_REGISTRY=${DRYCC_REGISTRY:-registry.drycc.cc}
IMAGE_PREFIX=${IMAGE_PREFIX:-drycc-addons}
CONTAINERS=($(git diff HEAD~1 --name-only | grep -E "containers/[a-z\-]{1,}/[0-9\.]{1,}" | awk -F '/' '{print $2"/"$3}' |sort -u))

build() {
    codename=${CODENAME:?CODENAME is require}
    for container in "${CONTAINERS[@]}"
    do
        project=$(echo $container | awk -F '/' '{print $1}')
        version=$(echo $container | awk -F '/' '{print $2}')
        image=$DRYCC_REGISTRY/$IMAGE_PREFIX/$project:$version-linux-$(dpkg --print-architecture)
        project_dir=$BASE_DIR/containers/$project/$version
        if [ -d "$project_dir" ]; then
            cd $project_dir
            podman build --build-arg CODENAME=$codename . -t $image
            podman push $image
            cd -
        fi
    done
}

manifest() {
    for container in "${CONTAINERS[@]}"
    do
        project=$(echo $container | awk -F '/' '{print $1}')
        version=$(echo $container | awk -F '/' '{print $2}')
        project_dir=$BASE_DIR/containers/$project/$version
        if [ -d "$project_dir" ]; then
            cp -rf .woodpecker/manifest.tmpl .woodpecker/manifest
            sed -i "s/{{project}}/${project}/g" .woodpecker/manifest
            sed -i "s/{{version}}/${version}/g" .woodpecker/manifest
            podman run --rm \
            -e PLUGIN_SPEC=.woodpecker/manifest \
            -e PLUGIN_USERNAME=$CONTAINER_USERNAME \
            -e PLUGIN_PASSWORD=$CONTAINER_PASSWORD \
            -v $(pwd):$(pwd) \
            -w $(pwd) \
            plugins/manifest
        fi
    done
}

"$1"