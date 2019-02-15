#!/bin/bash

# PREPARE the following env settings
MXE_HOME=${MXE_HOME:-/mnt/mxe}
PYTHON32_HOME=${PYTHON32_HOME:-$HOME/.wine/drive_c/python27-x86}
PYTHON64_HOME=${PYTHON64_HOME:-$HOME/.wine/drive_c/python27}
PATH=$MXE_HOME/usr/bin:$PATH

rm -rf ../nsis/build/*
mkdir -p ../nsis/build/{x86,GvimExt32,amd64,GvimExt64}

VIM_OPTIONS="Features=HUGE USERNAME=wangkexiong USERDOMAIN=NOKIA
             OLE=yes IME=yes MBYTE=yes IME=yes GIME=yes DYNAMIC_IME=yes
             CSCOPE=yes POSTSCRIPT=yes DEBUG=no MAP=no
             DIRECTX=yes COLOR_EMOJI=yes"

pushd ../vim/src

VIM32_OPTIONS="$VIM_OPTIONS PYTHON=$PYTHON32_HOME
               CROSS_COMPILE=i686-w64-mingw32.shared- WINDRES=i686-w64-mingw32.shared-windres"

make -f Make_ming.mak $VIM32_OPTIONS GUI=yes -j 8
cp gvim.exe ../../nsis/build/x86/gvim.exe
make -f Make_ming.mak $VIM32_OPTIONS GUI=yes clean

make -f Make_ming.mak $VIM32_OPTIONS GUI=no -j 8
cp vim.exe ../../nsis/build/x86/vim.exe
cp install.exe ../../nsis/build/x86/install.exe
cp uninstal.exe ../../nsis/build/x86/uninstal.exe
cp vimrun.exe ../../nsis/build/x86/vimrun.exe
cp tee/tee.exe ../../nsis/build/x86/tee.exe
cp xxd/xxd.exe ../../nsis/build/x86/xxd.exe
cp GvimExt/gvimext.dll ../../nsis/build/GvimExt32/gvimext.dll
make -f Make_ming.mak $VIM32_OPTIONS GUI=no clean
$MXE_HOME/tools/copydlldeps.sh -c -d ../../nsis/build/GvimExt32 -s $MXE_HOME/usr/i686-w64-mingw32.shared/bin -F ../../nsis/build/GvimExt32
$MXE_HOME/tools/copydlldeps.sh -c -d ../../nsis/tools/x86 -s $MXE_HOME/usr/i686-w64-mingw32.shared/bin -F ../../nsis/build/x86

VIM64_OPTIONS="$VIM_OPTIONS PYTHON=$PYTHON64_HOME
               CROSS_COMPILE=x86_64-w64-mingw32.shared- WINDRES=x86_64-w64-mingw32.shared-windres"

make -f Make_ming.mak $VIM64_OPTIONS GUI=yes -j 8
cp gvim.exe ../../nsis/build/amd64/gvim.exe
make -f Make_ming.mak $VIM64_OPTIONS GUI=yes clean

make -f Make_ming.mak $VIM64_OPTIONS GUI=no -j 8
cp vim.exe ../../nsis/build/amd64/vim.exe
cp install.exe ../../nsis/build/amd64/install.exe
cp uninstal.exe ../../nsis/build/amd64/uninstal.exe
cp vimrun.exe ../../nsis/build/amd64/vimrun.exe
cp tee/tee.exe ../../nsis/build/amd64/tee.exe
cp xxd/xxd.exe ../../nsis/build/amd64/xxd.exe
cp GvimExt/gvimext.dll ../../nsis/build/GvimExt64/gvimext.dll
make -f Make_ming.mak $VIM64_OPTIONS GUI=no clean
$MXE_HOME/tools/copydlldeps.sh -c -d ../../nsis/build/GvimExt64 -s $MXE_HOME/usr/x86_64-w64-mingw32.shared/bin -F ../../nsis/build/GvimExt64
$MXE_HOME/tools/copydlldeps.sh -c -d ../../nsis/tools/amd64 -s $MXE_HOME/usr/x86_64-w64-mingw32.shared/bin -F ../../nsis/build/amd64

pushd po
make -f Make_ming.mak install-all
popd

sed -e 's/[  ]*\*[-a-zA-Z0-9.]*\*//g' -e 's/vim:tw=78:.*//' ../runtime/doc/uganda.txt | uniq > ../../nsis/uganda.nsis.txt
7z x ../nsis/icons.zip -o../../nsis -y
cp ../nsis/gvim_version.nsh ../../nsis/.

popd

