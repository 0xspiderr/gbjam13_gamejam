#!/bin/sh
echo -ne '\033c\033]0;GBJAM13_gamejam\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/deal_or_no_dame.x86_64" "$@"
