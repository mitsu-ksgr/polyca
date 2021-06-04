#!/usr/bin/env bash
#------------------------------------------------------------------------------
#
# theme scsss generator.
#
# * Input
#   - themes/*.scss
#
# * Output
#   - src/themes/_import_thems.scss
#   - src/themes/_*.scss
#
#------------------------------------------------------------------------------

set -u
umask 0022
export LC_ALL=C
readonly SCRIPT_NAME=$(basename $0)


#
# Defines
#
readonly FILE_PATH_IMPORTER_FILE_PATH="./src/themes/_theme_importer.scss"
readonly FILE_PATH_STYLE_TEMPLATE="./templates/style.scss"
readonly STYLE_TEMPLATE_TAG="theme-xxxx"

auto_gen_theme_header() {
    cat << __EOS__
//
// !!! DO NOT EDIT THIS FILE DIRECTLY !!!
// this file was auto-generated by $SCRIPT_NAME
// if you want to modify it, edit the $1 and run $SCRIPT_NAME
//
__EOS__
}

auto_gen_importer_header() {
    cat << __EOS__
//
// this file was auto-generated by $SCRIPT_NAME.
// Note that $SCRIPT_NAME may be called via 'yarn build' or 'yarn compile'.
//
__EOS__
}

#
# Usage
#
usage () {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [-h]

Description:
    theme scsss generator.

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
    #usage
    exit 1
}


gen_scss() {
    local file_path=$1

    local file_name=$(basename $file_path)
    local name="${file_name%.*}"
    local theme="theme-${name}"

    local file_scss="./src/themes/_${name}.scss"
    local file_work="${file_scss}.work"

    # validate theme file.
    if grep -q "\$${theme}:" $file_path; then
        :   # OK
    else
        err "$file_path - you need to make the filename and the theme variable name the same."
    fi

    # 1. touch working file
    if [ -f "$file_work" ]; then
        rm $file_work
    fi
    touch $file_work

    # 2. write scss to working file
    auto_gen_theme_header $file_path >> $file_work
    cat $file_path >> $file_work
    echo -e "\n" >> $file_work
    cat $FILE_PATH_STYLE_TEMPLATE |\
        sed -e "s/${STYLE_TEMPLATE_TAG}/${theme}/g" \
        >> $file_work

    # 3. overwrite scss file with the contents of working file.
    mv $file_work $file_scss
    echo "Generated theme file: $file_scss"
}


update_importer() {
    local theme_dir=$1
    local importer_file_name=$(basename $FILE_PATH_IMPORTER_FILE_PATH)

    local file_work="${FILE_PATH_IMPORTER_FILE_PATH}.work"
    if [ -f "$file_work" ]; then
        rm $file_work
    fi
    touch $file_work

    auto_gen_importer_header >> $file_work
    echo -e "\n" >> $file_work

    for f in $(ls ${theme_dir}/*.scss); do
        local file_name=$(basename $f)

        if [ "$file_name" = "$importer_file_name" ]; then
            : # ignore importer file.
        else
            local name=$(echo "${file_name%.*}" | sed -e 's/_//')
            echo "@import '${name}';" >> $file_work
        fi
    done

    mv $file_work $FILE_PATH_IMPORTER_FILE_PATH
    echo "Update importer file: $FILE_PATH_IMPORTER_FILE_PATH"
}


#
# Entrypoint
#
main() {
    parse_args $@
    shift `expr $OPTIND - 1`

    # cd project root.
    cd $(dirname $0)/../


    for f in $(ls ./themes/*.scss); do
        gen_scss $f
    done

    update_importer "./src/themes"

    exit 0
}

main $@
exit 0

