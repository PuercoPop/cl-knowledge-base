(in-package #:cl-knowledge-base)

(defun clear-routes ()
  (setf *dispatch-table* (last *dispatch-table*)))

(define-easy-handler (top-level :uri "/") ()
  "The entry point to the Q&A portal."
  (show-tags (list-tags)))

(defmacro define-regexp-route (name (url-regexp &rest capture-names) &body body)
  (multiple-value-bind (body declarations documentation)
      (parse-body body :documentation t)
    `(progn
       (defun ,name ()
         ,@(when documentation
             (list documentation))
         ,@declarations
         (match (script-name *request*)
           ((ppcre ,url-regexp ,@capture-names)
            ,@body)))
       (push (create-regex-dispatcher ,url-regexp ',name)
             *dispatch-table*))))

(define-regexp-route tag-detail ("^/tag/(\\w+)/$" tag-name)
  "List all the questions tagged TAG-NAME."
  (when-let ((tag (get-tag-by-name tag-name)))
    (show-tag tag)))

(define-regexp-route question-detail ("^/question/(\\d+)/$" question-id)
  "Renders the question with QUESTION-ID."
  (when-let ((question (get-question-by-id (parse-integer question-id))))
    (show-question question)))
