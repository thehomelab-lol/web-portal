#!/bin/bash
set -e

HUGO_VERSION="0.160.1"
HUGO_TAR="hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_TAR}"

echo "Downloading Hugo extended v${HUGO_VERSION}..."
curl -sL "$HUGO_URL" | tar -xz hugo

echo "Hugo version:"
./hugo version

echo "Building site..."
./hugo --minify
