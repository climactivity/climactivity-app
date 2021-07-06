IFS=$'\n'; set -f
for f in $(find . -name '*.png' -or -name '*.doc'); do convert "$f" -resize 50% "$f"; done
unset IFS; set +f