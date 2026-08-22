#!/bin/bash

# WARN: differs significantly from:
# https://gohugo.io/host-and-deploy/host-on-cloudflare/
# but it's clearly overengineered.

# WARN: will not work, because UI set env vars are used to setup env before this runs.
# export HUGO_VERSION = "0.164.0"
# export GO_VERSION = "1.26.5"
# export DART_SASS_VERSION = "1.102.0"

# Stop execution if any command fails
set -e

echo "downloading dart-sass v${DART_SASS_VERSION}..."
curl -sLJO "https://github.com/sass/dart-sass/releases/download/${DART_SASS_VERSION}/dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"

echo "Extracting dart-sass..."
mkdir -p "${HOME}/.local"
tar -C "${HOME}/.local" -xf "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"
rm "dart-sass-${DART_SASS_VERSION}-linux-x64.tar.gz"

echo "adding dart-sass to PATH..."
export PATH="${HOME}/.local/dart-sass:${PATH}"

echo "configuring git..."
git config core.quotepath false

# Cloudflare exposes $CF_PAGES_BRANCH and $CF_PAGES_URL
if [ "$CF_PAGES_BRANCH" == "master" ]; then
  echo "production build..."
  # WARN: will break the unhashed production preview, because baseURL will remain what's set in hugo.toml,
  # and CSP will disallow.
  hugo build --gc --minify
else
  echo "staging build on branch: $CF_PAGES_BRANCH"
  # $CF_PAGES_URL is full deploy URL.
  # hugo build --gc --minify --buildDrafts --buildFuture --baseURL "$CF_PAGES_URL"

  # TODO: this is somewhat a hack. the reason for this is that I don't want to go into the UI to get
  # the random hashed deploy URL, eg: https://f45c57c1.bartholomy.pages.dev/
  # NOTE: lower and transform any unusual char to hyphen:
  SAFE_BRANCH=$(echo "$CF_PAGES_BRANCH" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
  BRANCH_URL="https://${SAFE_BRANCH}.bartholomy.pages.dev"
  hugo build --gc --minify --buildDrafts --buildFuture --baseURL "$BRANCH_URL"
fi
