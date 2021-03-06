#!/usr/bin/env bash

# Declaring exceptions for current script 
exceptions["100"]="Error: deploy_path is not writable";

function dep_prepare() {
    # Checking if $deploy_path is writable
    if [[ ! -w $(dirname $deploy_path) ]]; then
        exit 100;
    fi

    if [[ ! -d $deploy_path ]]; then 
        mkdir -p $deploy_path
    fi

    cd $deploy_path && 
    if [[ ! -d $shared_dir ]]; then 
        mkdir $shared_dir
    fi

    cd $deploy_path && 
    if [[ ! -d $releases_dir ]]; then 
        mkdir $releases_dir
    fi
}