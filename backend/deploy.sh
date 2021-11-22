A="$1"
dest="--linux"
name="canary"
if [ "$A" = "$dest" ]
then
  name="x86_64-unknown-linux-gnu"
else
  echo "x86_64-apple-macosx"
fi
git reset --hard
git pull
rm -f Package.resolved
swift build
if [ -f ".build/release/CanaryBackend" ];then
    cp -r .build/release/CanaryBackend release/$name
  else  
    cp -r .build/debug/CanaryBackend release/$name
fi