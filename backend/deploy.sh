git reset --hard
git pull
swift build
cp -r .build/debug/CanaryBackend release/canary
