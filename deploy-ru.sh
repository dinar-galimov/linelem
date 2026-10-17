#!/bin/sh
# Builds the Russian version and publishes it to the gh-pages branch (GitHub Pages).
set -e
cd "$(dirname "$0")"
rm -rf dist-ru && mkdir dist-ru
cp ru/index.html dist-ru/index.html
cp -R img icons fonts vendor dist-ru/
cp favicon.ico og.jpg site.webmanifest dist-ru/
touch dist-ru/.nojekyll
[ -f CNAME-ru ] && cp CNAME-ru dist-ru/CNAME
REMOTE=$(git remote get-url origin)
cd dist-ru
git init -q -b gh-pages
git add -A
git -c user.name="$(git -C .. config user.name || echo deploy)" -c user.email="$(git -C .. config user.email || echo deploy@localhost)" commit -qm "Publish Russian version"
git push -qf "$REMOTE" gh-pages
echo "Published to gh-pages"
