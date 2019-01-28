#! /bin/bash

curl -fsSL -o $MXE_TARGETS.tar.xz https://github.com/$TRAVIS_REPO_SLUG/releases/download/cc.core/$MXE_TARGETS.tar.xz
if [ -f $MXE_TARGETS.tar.xz ]; then
  tar xJvf $MXE_TARGETS.tar.xz > /dev/null
  rm -rf $MXE_TARGETS.tar.xz
  make download-cc
  if md5sum -c pkg.md5 > /dev/null 2>&1; then touch usr/installed/* usr/*/installed/*; fi
fi

