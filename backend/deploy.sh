git reset --hard
git pull
rm -f Package.resolved
swift build -c release
if [ -f ".build/release/CanaryBackend" ];then
    cp -r .build/release/CanaryBackend release/canary
  else  
    cp -r .build/debug/CanaryBackend release/canary
fi
