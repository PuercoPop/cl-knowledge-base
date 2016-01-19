(in-package #:cl-knowledge-base)

(defvar *db-host* :unix
  "The address of the database")
(defvar *db-port* 28015)

(defvar *database*
  (make-instance 'postgresql/perec
                 :connection-specification '(:database  "cl-knowledge-base"
                                             :user-name "puercopop"
                                             :host *db-host*
                                             :password nil)))

(defmacro with-db ((socket-name &key (host *host*) (port *port*))
                   &body body)
  "Run the BODY with a socket bound to SOCKET-NAME "
  `(alet ((,socket-name (connect ,host ,port)))
     (finally (progn
                ,@body)
       (disconnect ,socket-name))))

(defmacro with-query ((result query) &body body)
  "Run the BODY with the result of QUERY bound to RESULT "
  (with-unique-names (query-result)
    (with-gensyms (socket-name)
      `(with-db (,socket-name)
         (alet ((,query-result (run ,socket-name (r ,query))))
           (progv '(,result) ,query-result
               ,@body))))))
