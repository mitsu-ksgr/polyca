#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# Create new theme.
#
#------------------------------------------------------------------------------

set -u
umask 0022
export LC_ALL=C
readonly SCRIPT_NAME=$(basename $0)

readonly TEMPLATE_FILE_PATH="./templates/theme.scss"


#
# Usage
#
usage () {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [-h] THEME_NAME

Description:
    create new theme file.

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

err() {
    echo -n "Error: " 1>&2
    echo $@ 1>&2
    usage
    exit 1
}


#
# Entrypoint
#
main() {
    parse_args $@
    shift `expr $OPTIND - 1`

    local name="${1+$1}"

    if [ -z $name ]; then
        err "theme name required."
    fi

    local path="./themes/${name}.scss"
    if [ -f $path ]; then
        err "theme file already exists."
    fi

    touch $path
    cat $TEMPLATE_FILE_PATH |\
        sed -e "s/theme-xxxx/theme-${name}/g" \
            -e "s/THEME_NAME/${name}/g" \
        >> $path

    echo "New theme file created! $path"

    exit 0
}

main $@
exit 0

