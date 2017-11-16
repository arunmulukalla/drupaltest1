#!/bin/bash

# Set build directory.
BUILD_DIR=src

# Set branch to build the project.
PROFILE_BRANCH=$1

# Set App Path (is empty by default).
APP_PATH=""

# Set DSN.
DB_NAME="test1"
DB_USERNAME="root"
DB_PASSWORD=""
DB_HOST="localhost"


# publish directories default
STAGING_PUBLISH_DIR=/tmp/publish/staging

# LOG4PHP settings
ENABLE_LOG4PHP=0


# SOLR settings



# Folder for encrypt secure key
ENCRYPT_SECURE_KEY_PATH=/tmp

# SMTP settings
SMTP_SERVER="localhost"
FROM_EMAIL_ADDRESS="arun.mulukalla@valuelabs.com"
FROM_EMAIL_DISPLAY_NAME="TEST Support"

# Main host
MAIN_HOST="localhost"

# The project name 'test' and package suffix 'tgz' is used in Jekins job set up.
PROJ_NAME=test

# Remove build directory to delete files from previous build.
rm -rf $BUILD_DIR

SITE_DIR=$BUILD_DIR

# If the previous installation had been cancelled restore the defaults.
if [ -f ./distro.make.orig ]; then
    mv distro.make.orig distro.make
fi

if [ -f ./settings.php.orig ]; then
    mv settings.php.org settings.php
fi


# Launch the make process from 'distro.make' file.
# The distro.make contains instruction for downloading proper Drupal core and site profile versions.

