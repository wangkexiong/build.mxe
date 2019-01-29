#! /bin/bash

if [ "x$GITHUB_TOKEN" == "x" ]; then
  echo "GITHUB_TOKEN NOT set... Unable to update commit..."
else
  TIME=`date -R`

  git clone -b $TRAVIS_BRANCH https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG refresh_repo
  pushd refresh_repo
  sed -i "s/\*\*$MXE_TARGETS Last Build in:.*/\*\*$MXE_TARGETS Last Build in: $TIME\*\*/g" README.md
  git add README.md
  git commit --amend --date="$TIME" -m "daily build cc.core..."
  git push --force
  popd
  rm -rf refresh_repo

  # Check if update meets error
  for i in `seq 5`
  do
    DUR=`shuf -i5-15 -n1`
    echo "Sleep $DUR seconds..."
    sleep $DUR

    git clone -b $TRAVIS_BRANCH https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG refresh_repo

    pushd refresh_repo
    REF=`cat README.md | grep $MXE_TARGETS | tr -d \* | gawk -F ": " '{print $2}'`
    if [ "$TIME" == "$REF" ]; then
      popd
      rm -rf refresh_repo
      break
    else
      sed -i "s/\*\*$MXE_TARGETS Last Build in:.*/\*\*$MXE_TARGETS Last Build in: $TIME\*\*/g" README.md
      git add README.md
      git commit --amend --date="$TIME" -m "daily build cc.core..."
      git push --force
      popd
      rm -rf refresh_repo
    fi
  done
fi

