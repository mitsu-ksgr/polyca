#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# Watch & Auto compile.
#
#------------------------------------------------------------------------------
set -u
umask 0022
export LC_ALL=C
readonly SCRIPT_NAME=$(basename $0)


usage () {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [-h]

Description:
    auto compile scss.

Options:
    -h  show usage.

__EOS__
}

parse_args() {
    while getopts h flag; do
        case "${flag}" in
            h )
                usage
                exit 0
                ;;

            * )
                usage
                exit 0
                ;;
        esac
    done
}

update() {
    yarn compile
}

main() {
    parse_args $@
    shift `expr $OPTIND - 1`

    # cd project root.
    cd $(dirname $0)/../

    local watch_events="close_write,moved_to,delete"
    local watch_target="./src ./src/themes ./themes"
    inotifywait -m -e $watch_events --format "%f,%e" $watch_target |
    while IFS=, read -r file event; do
        #echo "$file, Event=$event"

        local ext="${file##*.}"
        case $event in
            "CLOSE_WRITE,CLOSE" )
                if [ "$ext" = "scss" ]; then
                    update
                fi
                ;;
            "DELETE" )
                if [ "$ext" = "scss" ]; then
                    update
                fi
                ;;
        esac
    done

    exit 0
}

main $@
exit 0

