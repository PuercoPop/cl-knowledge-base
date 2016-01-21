(in-package #:asdf-user)

(defsystem #:cl-knowledge-base
  :license "<3"
  :depends-on (#:alexandria
               #:babel
               #:hunchentoot
               #:hu.dwim.perec.postgresql
               #:hu.dwim.perec
               #:markdown.cl
               #:snooze
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
               (:file "parse-markdown" :depends-on ("model"))
               (:file "templates")
               (:file "controllers" :depends-on ("model"))
               (:file "cl-knowledge-base")))
