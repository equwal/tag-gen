#!/bin/sh
sbcl --load tag-gen.lisp \
  --eval '(tag-gen:main "config/local.conf" 2)' \
  --quit
