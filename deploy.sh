#!/usr/bin/env bash
declare -r home_dir=$(dirname "$0");
declare -A exceptions;

source "$home_dir/src/functions.sh"
source "$home_dir/src/parse_yaml.sh"

source "$home_dir/src/dep_prepare.sh"
source "$home_dir/src/dep_release.sh"
source "$home_dir/src/dep_update_code.sh"
source "$home_dir/src/dep_shared.sh"
source "$home_dir/src/dep_vendors.sh"
source "$home_dir/src/dep_writable.sh"
source "$home_dir/src/dep_clear_path.sh"
source "$home_dir/src/dep_success.sh"

source "$home_dir/src/magento2/database.sh"
source "$home_dir/src/magento2/setup.sh"
source "$home_dir/src/magento2/maintenance.sh"
source "$home_dir/src/magento2/deploy.sh"


if [[ ! -z $1 ]]; then
    config_path=$1;
else 
    config_path="$home_dir/config.yml";
fi

# Reading configuration
create_variables "$config_path"


# Declearing constants
declare -r shared_dir="shared";
declare -r releases_dir="releases";
declare -r release="release";
declare -r current="current";

declare -a tasks=(
    "dep_prepare"       # Prepairing host for deploy
    "dep_release"       # Creating a folder for new release
    "dep_update_code"   # Downloading code for new release
    "dep_shared"        # Creating shared folders
    "dep_vendors"       # Calling composer install method
    "dep_writable"      # Setting permissions to files and folders
    "dep_clear_path"    # Clearing paths

    "m2_db_create"          # Creating database if it doesn`t exists
    "m2_install"            # Installing Magento 2 application
    "m2_deploy_mode_set"
    "m2_maintenance_enable" 
    "m2_db_upgrade"
    "m2_di_compile"
    "m2_deploy_assets"
    "m2_cache_clean"
    "m2_maintenance_disable"
    
    "dep_success"
);

try
(
    for task in ${tasks[*]}; do
        logTask "${task}";
        ${task}
    done
) 
catch || {
    printError "${exceptions[$ex_code]}"
    exit 1;
}

printSuccess "Deploying is finished";