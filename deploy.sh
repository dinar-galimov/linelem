#!/bin/sh
# Publishes both language versions to GitHub Pages:
#   ru/index.html -> dinar-galimov/linelem    (gh-pages) -> linelem.art
#   en/index.html -> dinar-galimov/linelem-en (gh-pages) -> linelem.com
set -e
cd "$(dirname "$0")"

publish() { # $1 = lang folder, $2 = domain, $3 = repo, $4 = preview image
  out="dist-$1"
  rm -rf "$out" && mkdir "$out"
  cp "$1/index.html" "$out/index.html"
  cp -R img icons fonts vendor "$out/"
  cp favicon.ico site.webmanifest "$4" "$out/"
  touch "$out/.nojekyll"
  echo "$2" > "$out/CNAME"
  # relative asset paths: work on the custom domain and on username.github.io/<repo>/
  sed -i.bak -e 's#"/img/#"img/#g' -e 's#"/icons/#"icons/#g' -e 's#"/fonts/#"fonts/#g' -e 's#"/vendor/#"vendor/#g' -e 's#"/site.webmanifest"#"site.webmanifest"#g' "$out/index.html"
  sed -i.bak -e 's#url(/fonts/#url(#g' "$out/fonts/fonts.css"
  sed -i.bak -e 's#"/icons/#"icons/#g' "$out/site.webmanifest"
  rm -f "$out"/*.bak "$out"/fonts/*.bak
  (
    cd "$out"
    git init -q -b gh-pages
    git add -A
    git -c user.name="$(git -C .. config user.name || echo deploy)" -c user.email="$(git -C .. config user.email || echo deploy@localhost)" commit -qm "Publish $2"
    git push -qf "https://github.com/$3.git" gh-pages
  )
  echo "Published $2"
}

case "${1:-all}" in
  ru)  publish ru linelem.art dinar-galimov/linelem og.jpg ;;
  en)  publish en linelem.com dinar-galimov/linelem-en og-en.jpg ;;
  all) publish ru linelem.art dinar-galimov/linelem og.jpg
       publish en linelem.com dinar-galimov/linelem-en og-en.jpg ;;
esac
