#!/usr/bin/env bash

if [ "$TRAVIS_EVENT_TYPE" = "push" ] && [ "$TRAVIS_BRANCH" = "master" ]; then
  # Deploy pushes to master to Firebase hosting.
  echo "Deploying to Firebase."

  firebase -P flutter-es --token "$FIREBASE_TOKEN" --non-interactive deploy

fi