(in-package #:cl-knowledge-base)

(defvar *db-host* :unix
  "The address of the database")
(defvar *db-port* 28015)

(defvar *database*
  (make-instance 'postgresql/perec
                 :connection-specification `(:database  "cl-knowledge-base"
                                             :user-name "puercopop"
                                             :host ,*db-host*
                                             :password nil)))


