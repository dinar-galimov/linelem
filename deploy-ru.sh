#!/bin/sh
# Builds the Russian version and publishes it to the gh-pages branch (GitHub Pages).
set -e
cd "$(dirname "$0")"
rm -rf dist-ru && mkdir dist-ru
cp ru/index.html dist-ru/index.html
cp -R img icons fonts vendor dist-ru/
cp favicon.ico og.jpg site.webmanifest dist-ru/
touch dist-ru/.nojekyll
# relative asset paths so the site works both at username.github.io/linelem/ and on its own domain
sed -i.bak -e 's#"/img/#"img/#g' -e 's#"/icons/#"icons/#g' -e 's#"/fonts/#"fonts/#g' -e 's#"/vendor/#"vendor/#g' -e 's#"/site.webmanifest"#"site.webmanifest"#g' dist-ru/index.html
sed -i.bak -e 's#url(/fonts/#url(#g' dist-ru/fonts/fonts.css
sed -i.bak -e 's#"/icons/#"icons/#g' dist-ru/site.webmanifest
rm -f dist-ru/*.bak dist-ru/fonts/*.bak
[ -f CNAME-ru ] && cp CNAME-ru dist-ru/CNAME
REMOTE=$(git remote get-url origin)
cd dist-ru
git init -q -b gh-pages
git add -A
git -c user.name="$(git -C .. config user.name || echo deploy)" -c user.email="$(git -C .. config user.email || echo deploy@localhost)" commit -qm "Publish Russian version"
git push -qf "$REMOTE" gh-pages
echo "Published to gh-pages"
