(defpackage #:cl-knowledge-base
  (:use #:cl
        #:alexandria
        #:babel
        #:hunchentoot
        #:trivia
        #:trivia.ppcre)
  (:documentation "A Q&A site.

/: The top level shows all the tags.
/<tag>/: The list of all the questions tagged with <tag>.
/<tag>/id: The question.")
  (:export
   #:start))
