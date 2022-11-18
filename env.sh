#! /bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

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

Usage: $0 build [[-d|--dotnet] | [-h|--help]] 

Arguments:
    -d, --dotnet:   Build docker container with dotnet environment.
    -h, --help:     Show build script usage help.

EOF
}


help_run_script() {
cat << EOF

Usage: $0 run [[-d|--dotnet] | [-h|--help]] 

Arguments:
    -d, --dotnet:   Run docker container with dotnet environment.
    -h, --help:     Show run script usage help.

EOF
}

run() {

local option=${1:--h}

case ${option} in
    -h|--help)
        help_run_script
        ;;
    -d|--dotnet)
        echo -e "dotnet\n"
        ;;
    *)
        echo -e "${RED}Unknown argument: $1!${ENDCOLOR}"
        help_run_script
        ;;
esac

return 0
}

build() {

local option=${1:--h}

case ${option} in
    -h|--help)
        help_build_script
        ;;
    -d|--dotnet)
        echo -e "dotnet\n"
        #build $@
        ;;
    *)
        echo -e "${RED}Unknown argument: $1!${ENDCOLOR}"
        help_build_script
        ;;
esac

return 0
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
        echo -e "run\n"
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