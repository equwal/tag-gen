#!/bin/sh
sbcl --load tag-gen.lisp \
  --eval '(tag-gen:main "config/local.conf" "/usr/bin/exuberant-ctags" 2)' \
  --quit
