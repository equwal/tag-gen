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
  (:use #:cl)
  (:export #:main))

(in-package :tag-gen)

(defvar *log-level* 0)

(defun add-to-log (str-log level)
  (when (and (/= 0 *log-level*)
             (>= *log-level* level))
    (format t "~A~%" str-log)))

(defun tag-gen (tags tag-program)
  (labels ((extensions (dir exts)
             (when exts
               (add-to-log tags 2)
               (add-to-log
                (or (and (not (uiop:directory-exists-p dir))
                         (cons (format nil "The directory ~A doesn't exist" dir) 1))
                    (uiop:run-program (format nil
                                               "find ~A -type f -iname \"*.~A\" | ~A -"
                                               dir
                                               (car exts)
                                               tag-program)
                                       :ignore-error-status t
                                       :output '(string :stripped t)))
                    2)
               (extensions dir (cdr exts)))))
    (when tags
      (extensions (caar tags) (cadar tags))
      (tag-gen (cdr tags) tag-program))))

(defun main (conf tag-program &optional (log-level *log-level*) &rest argv)
  (declare (ignorable argv))
  (let ((log-level (if (stringp log-level)
                       (parse-integer log-level)
                       log-level)))
    (setf *log-level* log-level)
    (with-open-file (s conf :direction :input)
      (tag-gen (read s) (uiop:unix-namestring tag-program)))))

; (main "/home/jose/.config/tag-gen/local.conf" "/usr/bin/exuberant-ctags" 2)
; (main "/home/jose/.config/tag-gen/root.conf" "/usr/bin/exuberant-ctags" 2)
