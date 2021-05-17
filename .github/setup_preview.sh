#!/bin/bash
set -e

# arguments:
# $1 - PR number
# $2 - Cloudflare Account ID used to preview PR builds (the API token defined as GH secret must have access to this account)

if [ $# -ne 2 ]; then
  echo 'Expected arguments: <PRNumber> <AccountID>'
  exit 2
fi

parent_folder_name=$(basename $(dirname $(realpath "$PWD")))

preview_settings_path='../../.github'

# handle developers.cloudflare.com special case
if [ "$parent_folder_name" != "products" ]; then
  preview_settings_path='../.github'
fi

echo Adding preview settings to wrangler.toml file

cat $preview_settings_path/preview_settings.toml >> wrangler.toml
sed "s#\[PRNUMBER\]#${1}#" -i wrangler.toml
sed "s#\[PREVIEWACCOUNTID\]#${2}#" -i wrangler.toml          

echo Updated wrangler.toml file:
cat wrangler.toml
