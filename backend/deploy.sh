ver="$1"
name="x86_64-unknown-linux-gnu"
if [ -z ver ]
then
  echo "请输入版本号: x.x.x"
  exit 1
fi
git reset --hard
git pull
rm -f Package.resolved
cnt=(`git log | wc -l`)
c=`echo $cnt | xargs`
echo "let ver = \"version $ver($c)\"" > Sources/Run/version.swift
if [ -d ".build" ];then
  rm -rf .build/$name
fi

swift build

if [ -f ".build/release/Run" ];then
    cp -r .build/release/Run release/$name
  else  
    cp -r .build/debug/Run release/$name
fi

echo "编译完成 $ver($c)"