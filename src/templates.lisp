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
    (:ul (loop :for document :in (tagged-documents-of tag)
               :collect (:li (:a :href (format nil "/question/~A/"
                                               (oid-of document))
                                 (title document)))))))

(defun show-document (document)
  (with-page (:title (title document))
    (:h2 (title document))
    (:div (body document))))
