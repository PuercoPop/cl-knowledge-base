(in-package #:cl-knowledge-base)

(defvar *server* nil
  "Clack handler. Useful for when one wants to stop the server.")

(defvar *http-host* "127.0.0.1")

(defvar *http-port* 8080)

(defun stop-server ()
  (when *server*
    (hunchentoot:stop *server*)))

(defun start-server ()
  (setf *server*
        (hunchentoot:start (make-instance 'easy-acceptor
                                          :address *http-host*
                                          :port *http-port*))))

#+(or)(load-questions
   (asdf:system-relative-pathname :cl-knowledge-base "knowledge-base/"))
