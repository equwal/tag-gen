Generate tags for a list of files and extensions.

# Requirements
- An ANSI Common Lisp
- A ctags-like program.

# Install

Run make in this folder.

Edit the config/ files with the paths you want tagged. Read the docs for your tag program to know how to tell it what languages to use.

Add a command to cron like:
```
*/29 * * * * su username -c 'tag-gen.sh      /path/to/tag-gen/local.conf /usr/bin/etags'
*/29 * * * * su root     -c 'tag-gen-root.sh /path/to/tag-gen/root.conf  /usr/bin/etags'
```
for routine tagging.

tags.conf needs to contain this kind of format:
```
"/path/to/ctags/program"

(("<directory>" ("<ext>"...))
  ...)
```
See examples in config-examples. Configuration is **mandatory** for the program to work. The format is just read with
the lisp reader and is very simple.
