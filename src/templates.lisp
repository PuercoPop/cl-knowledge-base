(in-package #:cl-knowledge-base)

(defmacro with-page ((&key title) &body body)
  "Base template"
   `(spinneret:with-html-string
      (:html
        (:head
         (:title ,title))
        (:body ,@body))))
