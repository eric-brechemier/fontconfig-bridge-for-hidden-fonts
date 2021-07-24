#!/bin/sh
# Help Fontconfig to discover hidden fonts
#
# Parameters:
#   * name: string, used to create a distinct folder for each font service
#   * cache: path, location of the parent folder of hidden fonts
#
cd "$(dirname "$0")"

fontServiceName="$1"
fontServiceCache="$2"

if test -z "$fontServiceName" -o -z "$fontServiceCache"
then
  echo "Usage: $0 name cache" 1>&2
  exit 1
fi

echo 'Help Fontconfig to discover hidden fonts'

xdgFolder="${XDG_DATA_HOME:-$HOME/.local/share}"
fontconfigFolder="$xdgFolder/fonts"
linksFolder="$fontconfigFolder/$fontServiceName"

inkscapeConfig="$HOME/Library/Application Support/org.inkscape.Inkscape/config"
if test -d "$inkscapeConfig"
then
  echo 'Add config to load fonts from shared XDG directory in Inkscape...'
  cp -R inkscape/fontconfig "$inkscapeConfig" || exit 2
fi

echo 'Remove existing links folder...'
rm -rf "$linksFolder" || exit 3

echo 'Create new symbolic links folder...'
mkdir -p "$linksFolder" || exit 4
cd "$linksFolder" || exit 5
pwd

echo 'Add symbolic links for current fonts...'
for filePath in "$fontServiceCache"/.*
do
  if test -f "$filePath"
  then
    # extract file name
    fileName="$(basename "$filePath")"
    # remove initial '.'
    linkName="${fileName#.}"
    # create symbolic link
    echo "$linkName -> $fileName"
    ln -s "$filePath" "$linkName"
  fi
done

echo 'Refresh font cache...'
fc-cache -v 2>&1 | grep "$linksFolder" | head -n 1
fc-list 2>&1 | grep "$linksFolder"

echo 'Done.'
