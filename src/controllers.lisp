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
      ((ppcre url-regexp tag-name)
       (with-transaction
         (when-let ((tag (get-tag-by-name tag-name)))
           (show-tag tag))))))
  (push (create-regex-dispatcher url-regexp #'tag-detail)
        *dispatch-table*))

(let ((url-regexp "^/question/(\\d+)/$"))
  (defun document-detail ()
    "Lists the questions tagged `tag-name'"
    (match (script-name *request*)
      ((ppcre url-regexp question-id)
       (with-transaction
         (when-let ((question (get-question-by-id (parse-integer question-id))))
           (show-document question))))))
  (push (create-regex-dispatcher url-regexp #'document-detail)
        *dispatch-table*))
