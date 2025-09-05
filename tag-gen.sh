#!/bin/sh
sbcl --load /home/jose/common-lisp/tag-gen/tag-gen.lisp \
  --eval '(tag-gen:main "config/root.conf" "/usr/bin/exuberant-ctags" 2)' \
  --quit
