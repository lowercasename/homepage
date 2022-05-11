#!/bin/sh

orogene -mdvf \
    -c src/config.toml \
    -i src/pages \
    -o build \
    -t src/template.html \
    -s src/style.css \
    -a src/assets \
    -b src/blog \
    -p src/post_template.html
