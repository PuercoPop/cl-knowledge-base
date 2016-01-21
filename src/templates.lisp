(in-package #:cl-knowledge-base)

(defmacro with-page ((&key title) &body body)
  "Base template"
   `(spinneret:with-html-string
      (:html
        (:head
         (:title ,title))
        (:body ,@body))))

(defun show-tags (tags)
  (with-page (:title "Cl Q&A")
    (:ul (loop :for tag :in tags
               :collect (:li (:a :href (format nil "/tag/~A/" (tag-name tag))
                                 (tag-name tag)))))))

(defun show-tag (tag)
  (with-page (:title (tag-name tag))
    (:ul (loop :for question :in (tagged-questions-of tag)
               :collect (:li (:a :href (format nil "/question/~A/"
                                               (oid-of question))
                                 (title question)))))))

(defun show-question (question)
  (with-page (:title (title question))
    (:h2 (title question))
    (:div (body question))))
