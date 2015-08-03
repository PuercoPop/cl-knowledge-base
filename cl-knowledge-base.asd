(in-package #:asdf-user)

(defsystem #:cl-knowledge-base
  :license "<3"
  :depends-on (#:markdown.cl
               #:split-sequence
               #:trivia
               #:trivia.ppcre
               #:spinneret
               #:clack
               #:babel)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "model")
               (:file "serialization" :depends-on ("model"))
               (:file "templates")
               (:file "controllers" :depends-on ("model"))
               (:file "router" :depends-on ("controllers"))
               (:file "cl-knowledge-base")))
