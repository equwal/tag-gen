#!/bin/sh
sbcl --load tag-gen.lisp \
  --eval '(tag-gen:main "config/root.conf" 2)' \
  --quit
