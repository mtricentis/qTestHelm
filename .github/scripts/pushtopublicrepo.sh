#!/bin/sh -ex

# Inspired from
#https://github.com/johno/actions-push-subdirectories/blob/master/entrypoint.sh#L10

FOLDER="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"
GITHUB_TAG="$4"
#API_TOKEN_GITHUB="$4"


CLONE_DIR=output_clone
echo 'check current directory'
pwd
#ls -ltr

apt-get update && apt-get install git
#apk add --no-cache git

git config --global user.email "mtricentis@g.com"
git config --global user.name "$GITHUB_USERNAME"


git clone "https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/$GITHUB_REPO.git" "$CLONE_DIR"
echo 'check current directory after Clone'
pwd


#ls -l


# find needs to be in the git repository directory
#find . | grep -v ".git" | grep -v "^\.*$" #| xargs rm -rf # delete all files (to handle deletions)
#find . -type f -not -iname '*/.github/*' -exec cp '{}' $CLONE_DIR '\;'

#rsync -avr --exclude='.github' --exclude='.git' "../$FOLDER"/* .

cp -r $FOLDER $CLONE_DIR
cd "$CLONE_DIR"
echo "After cd $CLONE_DIR"
#git remote set-url origin2 https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/$GITHUB_REPO.git
git branch -ra
git remote -v
ls -la
git tag $GITHUB_TAG
git add .
git commit --message "Update from $GITHUB_REPOSITORY"
#git push origin main
git push origin --tags

cd ..
echo "Done!"
