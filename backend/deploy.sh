#git reset --hard
#git pull
rm -f Package.resolved
swift build -c release
cp -r .build/debug/CanaryBackend release/canary
