#!/bin/bash -e

cnt=1

# ${cnt}. Init and update all submodules
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Init and update all submodules"
[[ ! -d src ]] && mkdir src
#cp -rf ./dep_gomodules/* ./src
./initsubmodule.sh
let cnt=cnt+1
echo " "

# ${cnt}. Check and import environment
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Check and import environment"
if [[ ! -f /opt/toolchain-sunxi/environment-setup-arm-openwrt-linux ]]; then
  echo "Please configuration corsscompile environment."
  exit 1
fi

if [[ -z ${GOPATH+x} ]]; then
  echo "Please configuration golang environment."
  exit 1
fi

echo "source /opt/toolchain-sunxi/environment-setup-arm-openwrt-linux"
source /opt/toolchain-sunxi/environment-setup-arm-openwrt-linux
GOPATH=`pwd`
let cnt=cnt+1
echo " "

# ${cnt}. Create release folder
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Create release folder"
rootpath=`pwd`
release_libpath=${rootpath}/release/usr/lib
release_binpath=${rootpath}/release/usr/bin
toolchain_libpath=/opt/toolchain-sunxi/toolchain/usr/lib
rm -f -r release
echo ${toolchain_libpath}
echo "make release libpath: ${release_libpath}"
mkdir -p ${release_libpath}
echo "make release binpath: ${release_binpath}"
mkdir -p ${release_binpath}

let cnt=cnt+1
echo " "

# ${cnt}. Build and release C++ related cmodule
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Build C++ related module"
subcnt=1
for subcmodule in $(cat cmodules.txt)
do
  echo ".........................................."
  echo "# ${cnt}.${subcnt}. Build ${subcmodule}"
  cd ${subcmodule}/src
  pwd
  rm -f *.so
  make

  # Release to cross-compile tools
  cp -f *.so ${toolchain_libpath}

  # Release to R16 release directory
  cp -f *.so ${release_libpath}

  cd ${rootpath}
  let subcnt=subcnt+1
done
let cnt=cnt+1
echo " "

# ${cnt}. Build and release RA
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Build and release RA"

# Build
cd `cat main_module.txt`
go clean
rm -f ra
GOARCH=arm CGO_ENABLED=1 go build -o ra -ldflags "-X smartconn.cc/tosone/ra_main/init.BuildStamp=`date '+%Y-%m-%d_%I:%M:%S%p'` -X smartconn.cc/tosone/ra_main/init.GitHash=`git rev-parse HEAD`" main.go

# Release to R16 release directory
cp -f ra ${release_binpath}
cd ${rootpath}
let cnt=cnt+1

# ${cnt}. Change all release file mode
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
echo "# ${cnt}. Change all release file mode"
chmod 755 -R release
