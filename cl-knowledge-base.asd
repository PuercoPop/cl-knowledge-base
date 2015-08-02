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
  :components ((:file "cl-knowledge-base")))
