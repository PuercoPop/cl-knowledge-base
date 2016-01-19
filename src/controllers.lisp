(in-package #:cl-knowledge-base)

(defun clear-routes ()
  (setf *dispatch-table* (last *dispatch-table*)))

(define-easy-handler (top-level :uri "/") ()
  "The entry point to the Q&A portal."
  (with-transaction
    (show-tags (list-tags))))

(let ((url-regexp "^/tag/(\\w+)/$"))
  (defun tag-detail ()
    (match (script-name *request*)
      ((ppcre "/tag/(\\w+)/$" tag-name)
       (with-transaction
         (when-let ((tag (get-tag-by-name tag-name)))
           (show-tag tag))))))
  (push (create-regex-dispatcher url-regexp #'tag-detail)
        *dispatch-table*))

(define-easy-handler (document-detail :uri "/tag/") (tag-name)
  "Lists the questions tagged `tag-name'"
  (with-transaction
    (show-tag (get-tag-by-name tag-name))))

#+(or)
(defun question-page (question-id)
  ""
  (destructuring-bind (title body) (retrieve-question question-id)
    `(200
      (:content-type "text/html")
      ,(babel:string-to-octets
        (with:page (:title title))
        body))))
