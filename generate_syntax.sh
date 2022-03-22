#!/usr/bin/env bash
set -euo pipefail

# the cp is just a way to track which css you might end up liking
#cp static/css/syntax.css static/css/syntax_$(date +'%Y_%m_%d_%H_%M_%S').css
hugo gen chromastyles --style=$1 > ./syntax.css
echo "@media (prefers-color-scheme: dark) {" >> ./syntax.css
hugo gen chromastyles --style=$2 >> ./syntax.css
echo "}" >> ./syntax.css
