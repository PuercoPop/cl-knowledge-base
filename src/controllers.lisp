(in-package #:cl-knowledge-base)

(defun clear-routes ()
  (setf *dispatch-table* (last *dispatch-table*)))

(define-easy-handler (top-level :uri "/") ()
  "The entry point to the Q&A portal."
  (with-transaction
    (show-tags (list-tags))))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defroute tag (:get :text/* tag-name)
    (with-transaction
      (when-let ((tag (get-tag-by-name tag-name)))
        (show-tag tag)))))

(defgenpath tag url-for-tag)

#+(or)
(let ((url-regexp "^/tag/(\\w+)/$"))
  (defun tag-detail ()
    (match (script-name *request*)
      ((ppcre url-regexp tag-name)
       (with-transaction
         (when-let ((tag (get-tag-by-name tag-name)))
           (show-tag tag))))))
  (push (create-regex-dispatcher url-regexp #'tag-detail)
        *dispatch-table*))

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defroute question (:get :text/* question-id)
    "Lists the questions tagged `tag-name'"
    (with-transaction
      (when-let ((question (get-question-by-id (parse-integer question-id))))
        (show-question question)))))

(defgenpath question url-for-question)

#+(or)
(let ((url-regexp "^/question/(\\d+)/$"))
  (defun question-detail ()
    "Lists the questions tagged `tag-name'"
    (match (script-name *request*)
      ((ppcre url-regexp question-id)
       (with-transaction
         (when-let ((question (get-question-by-id (parse-integer question-id))))
           (show-question question))))))
  (push (create-regex-dispatcher url-regexp #'question-detail)
        *dispatch-table*))
