#!/bin/sh -ex


FOLDER="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"

HELM_QTEST_VERSION="$4"
QTEST_MGR_APP_VERSION="$5"

HELM_INSIGHTS_VERSION="$6"
INSIGHTS_APP_VERSION="$7"

HELM_LAUNCH_VERSION="$8"
LAUNCH_APP_VERSION="$9"

HELM_PARAMETERS_VERSION="$10"
PARAMETERS_APP_VERSION="$11"

HELM_PULSE_VERSION="$12"
PULSE_APP_VERSION="$13"

HELM_SCENARIO_VERSION="$14"
SCENARIO_APP_VERSION="$15"

HELM_SESSION_VERSION="$16"
SESSION_APP_VERSION="$17"

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
git clone "https://$API_TOKEN_GITHUB@github.com/$GITHUB_USERNAME/qtest-chart.git" $CLONE_DIR

echo 'check current directory after Clone'
cd $CLONE_DIR
echo "After cd $CLONE_DIR"
git checkout -b $GITHUB_REPO
cp -r $FOLDER/* .
ls -ltr
#Update qtestManger Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_QTEST_VERSION"'/g' Charts/qtest-chart/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$QTEST_MGR_VERSION"'/g' Charts/qtest-chart/chart.yml

#Update insights Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_INSIGHTS_VERSION"'/g' Charts/qtest-insights/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$INSIGHTS_APP_VERSION"'/g' Charts/qtest-insights/chart.yml

#Update qtest-launch Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_LAUNCH_VERSION"'/g' Charts/qtest-launch/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$LAUNCH_APP_VERSION"'/g' Charts/qtest-launch/chart.yml

#Update qtest-parameters Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_PARAMETERS_VERSION"'/g' Charts/qtest-parameters/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$PARAMETERS_APP_VERSION"'/g' Charts/qtest-parameters/chart.yml

#Update qtest-pulse Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_PULSE_VERSION"'/g' Charts/qtest-pulse/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$PULSE_APP_VERSION"'/g' Charts/qtest-pulse/chart.yml

#Update qtest-scenario Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_SCENARIO_VERSION"'/g' Charts/qtest-scenario/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$SCENARIO_APP_VERSION"'/g' Charts/qtest-scenario/chart.yml

#Update qtest-session Helm and app verison
sed -i 's/\(.*version:.*\)/version: '"$HELM_SESSION_VERSION"'/g' Charts/qtest-session/chart.yml
sed -i 's/\(.*appVersion:.*\)/appVersion: '"$SESSION_APP_VERSION"'/g' Charts/qtest-session/chart.yml

git add --all
git commit --message "Update from $GITHUB_REPOSITORY"

git push origin $GITHUB_REPO --force

cd ..
echo "Done!"
