#!/bin/sh
# Stop helping Fontconfig to discover hidden fonts
#
# Parameter:
#   * name: string, used to create a distinct folder for each font service
#
cd "$(dirname "$0")"

fontServiceName="$1"

if test -z "$fontServiceName"
then
  echo "Usage: $0 name" 1>&2
  exit 1
fi

echo "Stop helping Fontconfig to discover hidden fonts for $fontServiceName"

xdgFolder="${XDG_DATA_HOME:-$HOME/.local/share}"
fontconfigFolder="$xdgFolder/fonts"
linksFolder="$fontconfigFolder/$fontServiceName"

inkscapeConfig="$HOME/Library/Application Support/org.inkscape.Inkscape/config"
inkscapeFontconfigConfFolder="$inkscapeConfig/fontconfig/conf.d"
inkscapeXdgFontsConf="$inkscapeFontconfigConfFolder/00-load-xdg-fonts.conf"
if test -d "$inkscapeFontconfigConfFolder"
then
  echo 'Remove config to load fonts from shared XDG directory in Inkscape...'
  if test -f "$inkscapeXdgFontsConf"
  then
    rm "$inkscapeXdgFontsConf"
  fi
  rmdir "$inkscapeFontconfigConfFolder"
fi

if test -d "$linksFolder"
then
  echo "Remove folder with symbolic links to $fontServiceName fonts..."
  rm -rf "$linksFolder"
fi

echo 'Done.'
