#! /bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"
BASE_DIR=$(dirname $(realpath "$0"))
DOTNET_IMAGE="dotnet_docker_env"

help_script() {
cat << EOF

Usage: $0 [[run] | [build] | [-h|--help]] 

Arguments:
    run:        Run environment in a docker container.
    build:      Build environment docker image.
    -h, --help: Show script usage help.

EOF
}

help_build_script() {
cat << EOF

Usage: $0 build [[-d|--dotnet] | [-u|--ui] | [-h|--help]] 

Arguments:
    -d, --dotnet:   Build docker container with dotnet environment.
    -u, --ui:       Build React UI app.
    -h, --help:     Show build script usage help.

EOF
}


help_run_script() {
cat << EOF

Usage: $0 run [[-d|--dotnet] | [-u|--ui] | [-h|--help]] 

Arguments:
    -d, --dotnet:   Run docker container with dotnet environment.
    -u, --ui:       Run React UI app.
    -h, --help:     Show run script usage help.

EOF
}

run() {

local option=${1:--h}
local returnValue=

case ${option} in
    -h|--help)
        help_run_script
        returnValue=$?
        ;;
    -d|--dotnet)
        echo -e "${YELLOW}Start dotnet app${ENDCOLOR}\n"
        docker run --rm -ti -p 4000:80 ${DOTNET_IMAGE}
        returnValue=$?
        ;;
    -u|--ui)
        echo -e "${YELLOW}Start ui React app${ENDCOLOR}\n"
        cd "${BASE_DIR}/ClientApp"
        npm start
        cd "${BASE_DIR}"
        returnValue=$?
        ;;
    *)
        echo -e "${RED}Unknown argument: $1!${ENDCOLOR}"
        help_run_script
        returnValue=$?
        ;;
esac

return $returnValue
}

build() {

local option=${1:--h}
local returnValue=

case ${option} in
    -h|--help)
        help_build_script
        returnValue=$?
        ;;
    -d|--dotnet)
        echo -e "${YELLOW}Start bulding${ENDCOLOR}\n"
        docker build -f "${BASE_DIR}/Dockerfile" -t ${DOTNET_IMAGE} ${BASE_DIR}
        returnValue=$?
        ;;
    -u|--ui)
        echo -e "${YELLOW}Start bulding${ENDCOLOR}\n"
        cd "${BASE_DIR}/ClientApp"
        npm install
        npm run build
        cd "${BASE_DIR}"
        returnValue=$?
        ;;
    *)
        echo -e "${RED}Unknown argument: $1!${ENDCOLOR}"
        help_build_script
        returnValue=$?
        ;;
esac

return $returnValue
}

command="$0 $@"
option=${1:--h}

case ${option} in
    -h|--help)
        help_script
        ;;
    build)
        shift
        build $@
        ;;
    run)
        shift
        run $@
        ;;
    *)
        echo -e "${RED}Unknown argument: $1!${ENDCOLOR}"
        help_script
        ;;
esac

if [ $? -ne 0 ]; then
    echo -e "${RED}\nExecution: ${command} failed!\n${ENDCOLOR}"
fi;

exit $?