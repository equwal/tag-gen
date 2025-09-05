;;;; Generate etags for a list of files.
;;;; Add a command to cron like:
;;;; 0 0 * * * tag-gen ~/.config/tag-gen/tags.conf
;;;;
;;;; tags.conf needs to contain this kind of format:
;;;; (("<directory>" ("<ext>"...))
;;;;   ...)
;;;;
;;;; For example:
;;;; (("/home/jose/.emacs.d" ("el"))
;;;;  ("/home/jose/src/sf/sbcl/sbcl" ("lisp" "c")))
;;;;
;;;; Keep in mind that the home shorthand ~ might not git expanded properly!
;;;;
;;;; For debugging, call with a debug argument 0, 1, 2 where:
;;;; - 0 is silent
;;;; - 1 is for serious errors
;;;; - 2 is for everything

(defpackage :tag-gen
  (:use #:cl #:uiop)
  (:export #:main))

(in-package :tag-gen)

(defun add-to-log (msg)
  (let ((msgstr (format nil "~a" msg)))
    (format t "~A~@[~%~]"
            msg
            (or (zerop (length msgstr))
                (char= #\Newline (char msgstr (1- (length msgstr))))))))

(defun tag-gen (tags tag-program)
  (labels ((extensions (dir exts)
             (when exts
               (and tags (add-to-log (car tags)))
               (add-to-log
                (or (and (not (directory-exists-p dir))
                         (cons (format nil "The directory ~A doesn't exist" dir) 1))
                    (run-program (format nil "find ~A -type f -iname \"*.~A\" | ~A -"
                                               dir
                                               (car exts)
                                               tag-program)
                                       :ignore-error-status t
                                       :output '(string :stripped t))))
               (extensions dir (cdr exts)))))
    (when tags
      (extensions (caar tags) (cadar tags))
      (tag-gen (cdr tags) tag-program))))

(defun main (conf tag-program &rest argv)
  (declare (ignorable argv))
  (with-open-file (s conf :direction :input)
      (tag-gen (read s) (unix-namestring tag-program))))

; (main "/home/jose/.config/tag-gen/local.conf" "/usr/bin/exuberant-ctags" 2)
; (main "/home/jose/.config/tag-gen/root.conf" "/usr/bin/exuberant-ctags" 2)
