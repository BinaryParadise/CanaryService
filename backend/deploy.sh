A="$1"
dest="--macos"
name="canary"
if [ "$A" = "$dest" ]
then
  name="x86_64-apple-macosx"
else
  name="x86_64-unknown-linux-gnu"
fi
git reset --hard
git pull
rm -f Package.resolved
swift build
if [ -f ".build/release/Run" ];then
    cp -r .build/release/Run release/$name
  else  
    cp -r .build/debug/Run release/$name
fi