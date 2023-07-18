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
        cd $BASE_DIR/containers/$project/$version
        docker build --build-arg CODENAME=$codename . -t $image
        docker push $image
        cd -
    done
}

manifest() {
    for container in "${CONTAINERS[@]}"
    do
        project=$(echo $container | awk -F '/' '{print $1}')
        version=$(echo $container | awk -F '/' '{print $2}')
        cp -rf .woodpecker/manifest.tmpl .woodpecker/manifest
        sed -i "s/{{project}}/${project}/g" .woodpecker/manifest
        sed -i "s/{{version}}/${version}/g" .woodpecker/manifest
        docker run --rm \
          -e PLUGIN_SPEC=.woodpecker/manifest \
          -e PLUGIN_USERNAME=$CONTAINER_USERNAME \
          -e PLUGIN_PASSWORD=$CONTAINER_PASSWORD \
          -v $(pwd):$(pwd) \
          -w $(pwd) \
          plugins/manifest
    done
}

"$1"