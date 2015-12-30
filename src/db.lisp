(in-package #:cl-knowledge-base)

(defvar *host* "127.0.0.1"
  "The address of the database")
(defvar *port* 28015)

(defmacro with-db ((socket-name &key (host *host*) (port *port*))
                   &body body)
  "Run the BODY with a socket bound to SOCKET-NAME "
  `(alet ((,socket-name (connect ,host ,port)))
     (unwind-protect (progn
                       ,@body)
       (disconnect ,socket-name))))

(defmacro with-query ((query result) &body body)
  "Run the BODY with the result of QUERY bound to RESULT "
  (with-gensyms (socket-name)
    `(with-db (,socket-name)
       (let ((,result (run ,socket-name ,query)))
         ,@body))))
