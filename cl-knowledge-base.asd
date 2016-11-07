(in-package #:asdf-user)

(defsystem #:cl-knowledge-base
  :license "<3"
  :depends-on (#:alexandria
               #:babel
               #:closer-mop
               #:hunchentoot
               #:ironclad
               #:markdown.cl
               #:spinneret
               #:split-sequence
               #:trivia
               #:trivia.ppcre)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "util")
               (:file "db")
               (:file "model" :depends-on ("db" "util"))
               (:file "parse-scriba" :depends-on ("model"))
               (:file "parse-markdown" :depends-on ("model"))
               (:file "templates")
               (:file "controllers" :depends-on ("model"))
               (:file "cl-knowledge-base")))
