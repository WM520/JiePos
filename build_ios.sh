export LANG=en_US.UTF-8
pod install
DATE=`date '+%Y%m%d%H%M'`
echo $DATE
agvtool new-version -all $DATE
bundle exec fastlane release

