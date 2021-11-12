git reset --hard
git pull
rm -f Package.resolved
swift build -c release
cp -r .build/release/CanaryBackend release/canary
