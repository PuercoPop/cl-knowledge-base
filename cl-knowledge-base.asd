(in-package #:asdf-user)

(defsystem #:cl-knowledge-base
  :license "<3"
  :depends-on (#:alexandria
               #:babel
               #:blackbird
               #:clack
               #:cl-async
               #:cl-rethinkdb
               #:markdown.cl
               #:spinneret
               #:split-sequence
               #:trivia
               #:trivia.ppcre)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "db")
               (:file "model")
               (:file "parse-scriba" :depends-on ("model"))
               (:file "templates")
               (:file "controllers" :depends-on ("model"))
               (:file "router" :depends-on ("controllers"))
               (:file "cl-knowledge-base")))
