(in-package #:cl-knowledge-base)

(defun top-level ()
  "The entry point to the Q&A portal."
  `(200 (:content-type "text/html")
        ,(babel:string-to-octets
          (with-page (:title "Cl Q&A")
            (:ul (loop :for tag :in (list-tags)
                       :collect (:li (:a :href (format nil "/tag/~A/" tag)
                                         tag))))))))

(defun tag-page (tag-name)
  "Lists the questions tagged `tag-name'"
  `(200 (:content-type "text/html")
        ,(babel:string-to-octets
          (with-page (:title tag-name)
            (loop
              :for question :in *questions*
              :when (member tag-name (tags question) :test #'string=)
                :collect (:h2 (title question))
              :when (member tag-name (tags question) :test #'string=)
                :collect (:raw (body question)))))))
