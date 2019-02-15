#! /bin/bash

if [ "x$GITHUB_TOKEN" == "x" ]; then
  echo "GITHUB_TOKEN NOT set... API will not work w/o this..."
elif [ "x$TRAVIS_TAG" == "x" ]; then
  echo "TRAVIS_TAG NOT set... travis-ci needs this for deploy..."
else
  curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/$TRAVIS_REPO_SLUG/releases/tags/$TRAVIS_TAG > release.txt
  RELEASE_URL=`cat release.txt | jq -r .url`
  if [ "$RELEASE_URL" == "null" ]; then
    echo "No such release: $TRAVIS_TAG"
  else
    echo "DELETE $TRAVIS_TAG: $RELEASE_URL"
    curl -s -H "Authorization: token $GITHUB_TOKEN" -X DELETE $RELEASE_URL
  fi

  git config remote.origin.url https://$GITHUB_TOKEN@github.com/$TRAVIS_REPO_SLUG
  echo "Delete remote tag $TRAVIS_TAG"
  git push origin :refs/tags/$TRAVIS_TAG
  git config remote.origin.url https://github.com/$TRAVIS_REPO_SLUG
fi

