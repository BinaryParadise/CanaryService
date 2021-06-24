git reset --hard
git pull
swift build
cp -r .build/release/CanaryBackend release/canary
