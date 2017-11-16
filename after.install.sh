#!/bin/bash

# Copy csv files.
cd src/sites/default/files
mkdir -p feeds
cp -a ../../../profiles/test/files/csv/* feeds/

# Set the path for ://public stream.
drush vset --yes file_public_path "sites/default/files"

# Importing csv files using feeds module.
#drush feeds-import degrees --file=files/feeds/Degrees.csv

# Disable additional log modules.
#drush dis log4php

# Set the default folder for source files of migration.
drush vset --yes test_migrate_default_dataset_dir "fullset_testing_sandbox"
drush vset --yes dblog_row_limit 1000000

# We don't need search indexing during migration.
drush search-api-disable topics
drush search-api-disable profiles
drush search-api-disable workflow

# Remove unnecessary user to avoid error messages during migration.
drush php-eval 'user_delete_multiple(range(5, 38));'

# Create db backup before migration.
#drush sql-dump --result-file=/home/vagrant/db_backups/before_migration.sql
