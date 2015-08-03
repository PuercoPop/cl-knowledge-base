(in-package #:cl-knowledge-base)

(defvar *handler* nil
  "Clack handler. Useful for when one wants to stop the server.")

(defun start ()
  (load-questions
   (asdf:system-relative-pathname :cl-knowledge-base "knowledge-base/"))
  (setf *handler* (clack:clackup *app*)))
