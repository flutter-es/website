#!/bin/bash

# Fast fail the script on failures.
set -e

BUILD=1
CHECK_LINKS=1
PUB_CMD="get"

while [[ "$1" == -* ]]; do
  case "$1" in
    --no-build) BUILD=; shift;;
    --no-check-links) CHECK_LINKS=; shift;;
    --no-get)   PUB_CMD=""; shift;;
    --up*)      PUB_CMD="upgrade"; shift;;
    -h|--help)  echo "Usage: $(basename $0) [-h|--help] [--no-get|--upgrade] [--no-[build|check-links]]";
                exit 0;;
    *)          echo "ERROR: Unrecognized option: $1. Use --help for details."; exit 1;;
  esac
done

# Write errors to stderr
function error() {
  echo "FAIL: $@" 1>&2
}

# Checks the formatting of the Dart files to make sure it conforms to dartfmt
# output.
function check_formatting() {
  # Read files one line at a time, in case there are spaces in the names.
  local fmt_result=()
  IFS=$'\n' fmt_result=($("$dartfmt" -n "$@" 2>&1))
  local fmt_code=$?
  if [[ "$fmt_code" != 0 ]]; then
    error "dartfmt exited with the following exit code: ${fmt_code}"
    error "${fmt_result[@]}"
    exit 1
  elif [[ "${#fmt_result[@]}" == 0 ]]; then
    echo "No formatting errors!"
  else
    error "There are formatting errors in the following files:"$'\n'
    for file in "${fmt_result[@]}"; do
      error "===== $file ====="
      cp "$file" "$file.expected"
      "$dartfmt" -w "$file.expected" &> /dev/null
      error "----- expected format -----"
      cat "$file.expected" 1>&2
      error "----- current format -----"
      cat "$file" 1>&2
      error "----- diff -----"
      diff "$file.expected" "$file" 1>&2
      error "===== /end $file ====="$'\n'
      rm "$file.expected"
    done
    return 1
  fi
}

# Deploys website to Firebase, trying up to total_tries times.
function deploy() {
  local total_tries="$1"
  local remaining_tries="$total_tries"
  local project="$2"
  while [[ "$remaining_tries" > 0 ]]; do
    # FIREBASE_TOKEN is set in the .cirrus.yml file.
    firebase deploy --token "$FIREBASE_TOKEN" --non-interactive --project "$project" && break
    remaining_tries=$(($remaining_tries - 1))
    error "Error: Unable to deploy project $project to Firebase. Retrying in five seconds... ($remaining_tries tries left)"
    sleep 5
  done

  [[ "$remaining_tries" == 0 ]] && {
    error "Deployment still failed after $total_tries tries: '$@'"
    return 1
  }
  return 0
}

# Used to reliably find the absolute location of this script.
function script_location() {
  local script_location="${BASH_SOURCE[0]}"
  # Resolve symlinks
  while [[ -h "$script_location" ]]; do
    DIR="$(cd -P "$(dirname "$script_location")" >/dev/null && pwd)"
    script_location="$(readlink "$script_location")"
    [[ "$script_location" != /* ]] && script_location="$DIR/$script_location"
  done
  echo "$(cd -P "$(dirname "$script_location")" >/dev/null && pwd)"
}

# Set the FLUTTER_ROOT and PATH, in case we're running this script locally.
# Assumes that the flutter dir is at the same level as the website dir.
FLUTTER_ROOT="${FLUTTER_ROOT:-$(script_location)/../../flutter}"
FLUTTER_ROOT="$(cd $FLUTTER_ROOT; pwd)"
echo "Using FLUTTER_ROOT '$FLUTTER_ROOT'"

export PATH="$FLUTTER_ROOT/bin/cache/dart-sdk/bin:$FLUTTER_ROOT/bin:$PATH"

if [[ ! -x "$FLUTTER_ROOT/bin/flutter" ]]; then
  error "The FLUTTER_ROOT variable must point to your Flutter repo for this "
  error "script to run correctly. Alternatively, it can be located as a sibling"
  error "to the 'website' directory."
  error "Currently looking for FLUTTER_ROOT in '$FLUTTER_ROOT'"
  exit 1
fi

# Use the version of Dart SDK from the Flutter repository instead of whatever
# version is in the PATH. FLUTTER_ROOT comes from the Cirrus Docker image.
# This is mainly guarding against something installing Dart (e.g. as a
# dependency) in another location and somehow getting into the PATH ahead of the
# one in FLUTTER_ROOT, or against a corrupt install of the SDK. It's unlikely,
# but we want to fail to find these if it happens.
dart="$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart"
dartfmt="$FLUTTER_ROOT/bin/cache/dart-sdk/bin/dartfmt"
pub="$FLUTTER_ROOT/bin/cache/dart-sdk/bin/pub"
flutter="$FLUTTER_ROOT/bin/flutter"

echo "Using Dart SDK: $dart"
"$dart" --version

if [[ -n $PUB_CMD ]]; then
  "$flutter" packages $PUB_CMD

  # Analyze the stand-alone sample code files
  for sample in _includes/code/*/*; do
    if [[ -d "${sample}" ]]; then
      echo "Run flutter packages $PUB_CMD on ${sample}"
      "$flutter" packages $PUB_CMD ${sample}
    fi
  done
fi

echo "ANALYZING _includes/code/*:"
"$flutter" analyze --no-current-package _includes/code/

#Evito la comprobacion de códigos insertados provisionalmente

# echo "EXTRACTING code snippets from the markdown:"
# "$dart" --preview-dart-2 tool/extract.dart

# echo "ANALYZING extracted code snippets:"
# "$flutter" analyze --no-current-package example/

# echo "DARTFMT check of extracted code snippets:"
# check_formatting example/*.dart

if [[ -n $BUILD ]]; then
  echo "BUILDING site:"
  bundle exec jekyll build
else
  echo "SKIPPING: site build"
fi

if [[ -n $CHECK_LINKS ]]; then
  echo "CHECKING links:"
  rake checklinks
  echo "SUCCESS: check links"
else
  echo "SKIPPING: check links"
fi

if [ "$TRAVIS_EVENT_TYPE" = "push" ] && [ "$TRAVIS_BRANCH" = "master" ]; then
  # Deploy pushes to master to Firebase hosting.
  echo "Deploying to Firebase."

  npm install --global firebase-tools
  firebase -P flutter-es --token "$FIREBASE_TOKEN" --non-interactive deploy

fi

exit 0