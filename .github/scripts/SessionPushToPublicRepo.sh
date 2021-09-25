#!/bin/sh -ex


FOLDER="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"

HELM_SESSION_VERSION="$4"
SESSION_APP_VERSION="$5"

CLONE_DIR=output_clone
echo 'check current directory'
#make directory
mkdir /home/runner/work/$GITHUB_USERNAME

cd /home/runner/work/$GITHUB_USERNAME
pwd
apt-get update && apt-get install git
#apk add --no-cache git

git config --global user.email "mtricentis@g.com"
git config --global user.name "$GITHUB_USERNAME"
git clone "https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/qtest_public.git" $CLONE_DIR

echo 'check current directory after Clone'
cd $CLONE_DIR
echo "After cd $CLONE_DIR"
git checkout -b $GITHUB_REPO
cp -r $FOLDER/* .
ls -ltr
#Update Session Helm and app verison
sed -i 's/\(^version:.*\)/version: '"$HELM_SESSION_VERSION"'/g' Charts/qtest-session/Chart.yaml
sed -i 's/\(^appVersion:.*\)/appVersion: '"$SESSION_APP_VERSION"'/g' Charts/qtest-session/Chart.yaml
git rm --cached .idea
git add --all
git commit --message "Update from $GITHUB_REPOSITORY"

git push origin $GITHUB_REPO --force

cd ..
echo "Done!"
