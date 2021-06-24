git reset --hard
git pull
swift build -c release
cp -r .build/release/CanaryBackend release/canary
