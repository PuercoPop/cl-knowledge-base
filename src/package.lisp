(defpackage #:cl-knowledge-base
  (:use #:cl
        #:alexandria
        #:hu.dwim.perec
        #:trivia
        #:trivia.ppcre)
  (:shadowing-import-from #:hu.dwim.perec
                          #:set)
  (:documentation "A Q&A site.

/: The top level shows all the tags.
/<tag>/: The list of all the questions tagged with <tag>.
/<tag>/id: The question.")
  (:export
   #:start))
