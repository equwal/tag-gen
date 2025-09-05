#!/bin/sh
sbcl --load tag-gen.lisp \
  --eval '(tag-gen:main "config/root.conf" "/usr/bin/exuberant-ctags" 2)' \
  --quit
