#!/bin/sh
sbcl --load /home/jose/common-lisp/tag-gen/tag-gen.lisp \
  --eval '(tag-gen:main "/home/username/.config/tag-gen/local.conf" "/usr/bin/exuberant-ctags" 2)' \
  --eval '(tag-gen:main "/home/username/.config/tag-gen/root.conf" "/usr/bin/exuberant-ctags" 2)' \
  --quit
