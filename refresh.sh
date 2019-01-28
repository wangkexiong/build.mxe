#! /bin/bash

if [ "x$GITHUB_TOKEN" == "x" ]; then
  echo "GITHUB_TOKEN NOT set... Unable to update commit..."
else
  TIME=`date -R`

  for i in `seq 5`
  do
    XYZ=`curl -k -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/repos/$TRAVIS_REPO_SLUG/contents/README.md?ref=$TRAVIS_BRANCH"`
    REF=`echo $XYZ | jq -r .content | base64 -d - | grep $MXE_TARGETS | tr -d \* | gawk -F ": " '{print $2}'`

    if [ "$TIME" == "$REF" ]; then
      break
    else
      DUR=`shuf -i5-15 -n1`
      echo "Sleep $DUR seconds..."
      sleep $DUR

      git clone -b $TRAVIS_BRANCH https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG refresh_repo
      pushd refresh_repo
      sed -i "s/\*\*$MXE_TARGETS Last Build in:.*/\*\*$MXE_TARGETS Last Build in: $TIME\*\*/g" README.md
      git add README.md
      git commit --amend --date="$TIME" -m "daily build cc.core..."
      git push --force
      popd
      rm -rf refresh_repo
    fi
  done
fi

