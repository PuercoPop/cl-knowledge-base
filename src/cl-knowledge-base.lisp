(in-package #:cl-knowledge-base)

(defvar *server* nil
  "Hunchentoot server. Useful for when one wants to stop the server.")

(defvar *http-host* "127.0.0.1")

(defvar *http-port* 8080)

(setf *catch-errors* :verbose
      *catch-http-conditions* :verbose)

(defun stop-server ()
  (when *server*
    (hunchentoot:stop *server*)))

(defun start-server ()
  (push (make-hunchentoot-app)
        *dispatch-table*)
  (setf *server*
        (hunchentoot:start (make-instance 'easy-acceptor
                                          :address *http-host*
                                          :port *http-port*))))

(defun populate-database ()
  "Load the questions to the database."
  (load-questions
   (asdf:system-relative-pathname :cl-knowledge-base "knowledge-base/")))

