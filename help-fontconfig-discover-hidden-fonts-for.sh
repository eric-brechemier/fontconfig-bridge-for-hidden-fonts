#!/bin/sh
# Help Fontconfig to discover hidden fonts
#
# Parameters:
#   * name: string, used in file names to differentiate each font service
#   * cache: path, location of the parent folder of hidden fonts
#
fontServiceName="$1"
fontServiceCache="$2"

if test -z "$fontServiceName" -o -z "$fontServiceCache"
then
  echo "Usage: $0 name cache" 1>&2
  exit 1
fi

echo 'Help Fontconfig to discover hidden fonts'

echo 'Create Fontconfig folder if missing'
fontconfigFolder="$HOME/.fonts"
mkdir -p "$fontconfigFolder" || exit 1
cd "$fontconfigFolder" || exit 2

echo 'Reset'
rm *."$fontServiceName".otf 2>/dev/null

for file in "$fontServiceCache"/.*
do
  if test -f "$file"
  then
    # extract file name without extension
    name="$(basename "$file" '.otf')"
    # remove initial '.', add custom extension
    name="${name#.}."$fontServiceName".otf"
    # create symbolic link
    echo "$name -> $file"
    ln -s "$file" "$name"
  fi
done

echo 'Refresh font cache'
fc-cache -v || exit 3

echo 'Done.'
