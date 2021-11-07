#!/bin/sh -ex


FOLDER="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"


HELM_QTEST_VERSION="$4"
QTEST_MGR_APP_VERSION="$5"
PUBLIC_REPO="$6"
APPLICATION_NAME="$7"

if [ "$APPLICATION_NAME" == "qtest-chart" ];
then 
  echo " I am in If condition - $$$$$$ "
fi
CLONE_DIR=output_clone
echo 'check current directory'
#make directory
mkdir /home/runner/work/$GITHUB_USERNAME

cd /home/runner/work/$GITHUB_USERNAME
pwd
apt-get update && apt-get install git
#apt-get add --no-cache git

git config --global user.email "mtricentis@g.com"
git config --global user.name "$GITHUB_USERNAME"
#git clone "https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/qtest_public.git" $CLONE_DIR
git clone "https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/$PUBLIC_REPO.git" $CLONE_DIR

echo 'check current directory after Clone'
cd $CLONE_DIR
echo "After cd $CLONE_DIR"
git checkout -b $GITHUB_REPO
#cp -r $FOLDER/Charts/qtest-chart/* Charts/qtest-chart
cp -r $FOLDER/Charts/$APPLICATION_NAME/* Charts/$APPLICATION_NAME
ls -ltr
#Update qtestManger Helm and app verison
#sed -i 's/\(^version:.*\)/version: '"$HELM_QTEST_VERSION"'/g' Charts/$APPLICATION_NAME/Chart.yaml
version="$HELM_QTEST_VERSION" yq -i eval '.version = env(version)' Charts/$APPLICATION_NAME/Chart.yaml
#sed -i 's/\(^appVersion:.*\)/appVersion: '"$QTEST_MGR_APP_VERSION"'/g' Charts/$APPLICATION_NAME/Chart.yaml
appversion="$QTEST_MGR_APP_VERSION" yq -i eval '.appVersion = env(appversion)' Charts/$APPLICATION_NAME/Chart.yaml
#yq -help
appversion="$QTEST_MGR_APP_VERSION" yq -i eval '.image.tag = env(appversion)' Charts/$APPLICATION_NAME/values.yaml
#yq -i e '.image.tag = '"$QTEST_MGR_APP_VERSION"'' Charts/$APPLICATION_NAME/values.yaml

#sed -i '/^image:/{n;s/tag:.*/tag: '"$QTEST_MGR_APP_VERSION"'/g}' Charts/$APPLICATION_NAME/values.yaml
git add --all
git commit --message "Update from $GITHUB_REPOSITORY"

git push origin $GITHUB_REPO --force

cd ..
echo "Done!"
