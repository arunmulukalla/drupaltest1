#!/bin/bash

# The project name 'test' and package suffix 'tgz' is used in Jenkins job set up.
PROJ_NAME=test
PACKAGE=$PROJ_NAME.tgz

# Directory where the package is built. 
BUILD_DIR=$PWD/dist
WORKING_DIR=$PWD

# Copy jwplayer from external lib to tmp folder
echo "WORKING_DIR=$WORKING_DIR"
cd /tmp/
mkdir test-lib
cd test-lib
mkdir jwplayer
cd $WORKING_DIR
ls
cp external-libraries/jwplayer-6.12.zip /tmp/test-lib/jwplayer/

# Remove build directory to delete files from previous build.
rm -rf $BUILD_DIR

SITE_DIR=$BUILD_DIR/$PROJ_NAME
SITE_ADMIN_DIR=$SITE_DIR/siteadmin/
MONITORS_DIR=$SITE_DIR/monitors/
SITE_ADMIN_ARCHIVE_DIR=$SITE_ADMIN_DIR/archive

# Launch the make process from 'distro.make' file.
# The distro.make contains instruction for downloading proper Drupal core and site profile versions.
cp distro.make distro.make.orig
echo "PROFILE_BRANCH= $PROFILE_BRANCH"
sed -i -e "s|$\$PROFILE_BRANCH\\$\\$|$PROFILE_BRANCH|g" distro.make
cat distro.make
drush make distro.make $SITE_DIR --working-copy --no-gitinfofile 2>&1 | tee drush.log
mv distro.make.orig distro.make

mkdir -p $SITE_ADMIN_DIR $MONITORS_DIR $SITE_ADMIN_ARCHIVE_DIR
mv drush.log $SITE_ADMIN_DIR

# Copy settings.php
cp settings.php $SITE_DIR/sites/default
cp settings.php $SITE_DIR/sites/default/settings.php.orig

# Copy test_full_migration.sh
cp test_full_migration.sh $SITE_DIR/sites/default
cp test_migration_snapshot_rollout.sh $SITE_DIR/sites/default

# copy all php files to SITE_ADMIN_DIR excluding settings.php and opsmonitor.php
cp *.php $SITE_ADMIN_DIR
#rm $SITE_ADMIN_DIR/opsmonitor.php
#rm $SITE_ADMIN_DIR/settings.php
# copy opsmonitor.php
cp opsmonitor.php $MONITORS_DIR
cp -r performance $SITE_ADMIN_DIR

#mv *.txt (except robots.txt) files into archive dir
mv $SITE_DIR/*.txt $SITE_ADMIN_ARCHIVE_DIR
mv $SITE_ADMIN_ARCHIVE_DIR/robots.txt $SITE_DIR/

#copy index.html
cp index.html $SITE_ADMIN_DIR

# Rewrite htaccess file
#cp $BUILD_DIR/$PROJ_NAME/profiles/test/.htaccess $BUILD_DIR/$PROJ_NAME/

# Generate version file
{
	echo "Jenkins Environment Variables"
	echo "-----------------------------"
	echo "BUILD_NUMBER         = $BUILD_NUMBER"
	echo "BUILD_ID             = $BUILD_ID"
	echo "BUILD_URL            = $BUILD_URL"
	echo "JOB_NAME             = $JOB_NAME"
	echo "NODE_NAME            = $NODE_NAME"
	echo "GIT_COMMIT           = $GIT_COMMIT"
	echo "GIT_BRANCH           = $GIT_BRANCH"
	echo "WORKSPACE            = $WORKSPACE"
	echo "TEST_BRANCH"         = $TEST_BRANCH
	echo "PROFILE_BRANCH" = $PROFILE_BRANCH

	echo ""
	
	# Get repository info
	
	OLD_DIR=$PWD
	
	for i in $PWD/ $SITE_DIR/profiles/test; do
		cd $i
		
		echo "*********************************************************************"	
		echo "Generating git info for $PWD"
		
		echo "git symbolic-ref  HEAD"
		git symbolic-ref  HEAD

		echo ""

		echo "git log -n 1"
		git log -n 1

		echo ""
		echo ""
	done	
	
	cd $OLD_DIR

} > $SITE_ADMIN_DIR/version.txt


# Create site package
tar cvzf $BUILD_DIR/$PACKAGE -C $SITE_DIR .

#Delete lib folder from /tmp location
rm -rf /tmp/test-lib
